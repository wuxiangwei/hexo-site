---
title: "dmClock源码分析之Sim模块"
date: 2016-11-11 15:01:26
categories: [mClock]
tags: [mClock]
toc: true
---

# 代码结构

## Sim

Sim模块构建一个模拟器来模拟一组客户机向一组服务主机发送请求，同时服务主机根据指定的QoS算法调度请求的处理顺序的过程。Sim提供了两种调度算法，一种是FCFS的简单调度算法，另一种就是dmClock调度算法。

``` C++
// TS代表服务，例如 SimulatedServer
// TC代表客户，例如 SimulatedClient
template<typename ServerId, typename ClientId, typename TS, typename TC>
class Simulation {
public:
    ServerMap servers; // 服务列表
    ClientMap clients; // 客户列表

    TimePoint early_time;  // 实例化时的时间
    TimePoint late_time;  // 客户结束的时间

    void display_stats();  // 打印统计信息
};
```

打印客户报告：

依赖于每个client的op_times属性，该属性记录每个请求完成时的时间。
打印报告时，对每个client每隔measure_unit(2s)秒打印一次IOPS数据。此外，调整report_unit参数能够等比例放大或者缩小IOPS的值便于查看分析结果。

打印服务报告：

打印每个服务处理的请求数目。

### 客户端

``` C++
class SimulatedClient {
protected:
    std::vector<CliInst> instructions;

    std::thread thd_req;
    std::thread thd_resp;

    // 性能数据收集
    std::vector<TimePoint> op_times;  // 请求完成的时间，从小到大排序

    void run_req();  // 发送请求的线程入口
    void run_resp();  // 接收响应的线程入口
    
    // 接收来自服务的响应
    void receive_response(
        const TestResponse& resp,
	    const ServerId& server_id,
	    const RespPm& resp_params
    );
};
```

CliInst类描述生成请求的指令（instruction），两种生成请求的方式：一种是生成count(1000)个请求，同时设定最多允许max_outstanding(100)个等待请求以及每个请求的时延time_bw_reqs(单位：微秒)；另一种只是等待。何为等待请求？已发送但未接收到响应的请求。

发送请求的流程：

1. 检查等待请求数目是否大于上限值max_outstanding，如果大于，则一直等待不发送请求。
2. 开始发送请求：
    a) 为给定的请求o选择一个处理请求的Server；
    b) 发送请求给a)中选定的Server；
    c) 递增等待的请求数目 outstanding_ops；
    d) 等待time_bw_reqs时间后，继续发生下个请求，即继续a)步骤。
3. 所有请求发送结束，设置标志位requests_complete为True。


处理响应的流程：

1. 检查响应队列是否为空，若为空，则等待1s后继续检查，若不为空，则继续步骤2；
2. 从响应队列中pop出一个响应，递减等待请求个数 outstanding_ops；
3. 如果还有没发送的请求，则通知发送流程继续发送请求；
4. 如果所有的请求还没发送结束，则跳转到步骤1继续执行；
4. 如果所有的请求已经发送结束，但还存在等待请求，则跳转到步骤2)继续执行；

### 服务端

``` C++
// Q代表优先级队列的类型
template<typename Q, typename ReqPm, typename RespPm, typename Accum>
class SimulatedServer {
	Q* priority_queue;  // 请求队列
    // 内部请求队列
    // 数据从priority_queue队列导入，导入策略由priority_queue队列定义
    std::deque<QueueItem> inner_queue; 
    // priority_queue向inner_queue投递请求
    void inner_post(
        const ClientId& client,
        std::unique_ptr<TestRequest> request,
        const RespPm& additional
    );

	ClientRespFunc	client_resp_f;  // 返回响应给客户
	int iops;  // Server的IOPS能力
    size_t thread_pool_size;  // 线程池的大小
    std::chrono::microseconds op_time;  // 处理1个IO花费的时间，用于模拟IO处理
    size_t thread_pool_size;
    ServerAccumFunc accum_f;

    std::chrono::microseconds op_time;  // 完成1个请求花费的时间

    // 接收客户请求
    void post(
        const TestRequest& request,  // 请求内容
        const ClientId& client_id,  // 客户id
        const ReqPm& req_params  // 请求参数
    );
};
```

Server属于自己的属性：IOPS(默认值 40)、线程数。IOPS代表Server每秒处理IO数目的能力。根据这个属性可以推算出处理一个IO花费的时间，即op_time属性。在IOPS能力给定的情况下，如果使用多线程，那么op_time的值为单线程的thread_pool_size倍。thread_pool_size为线程池的大小。

请求处理流程：

1. 检查内部队列是否为空。若为空，则等待1s后继续检查；
2. 从内部队列中pop一个请求，开始处理请求，即等待op_time时间；
3. 发送响应给客户。

SimulatedServer内部维护了两个队列：内部队列inner_queue和优先级队列priority_queue。内部队列是FCFS队列，Server处理请求时直接从该队列读取请求。priority_queue队列用于定义QoS调度算法，客户的请求将先入priority_queue队列，然后由priority_queue队列根据自己的算法将请求放入内部队列。

### 简单调度 ssched

``` C++
// 服务端参数
const uint server_count = 100;  // 服务数目
const uint server_iops = 40;  // 每个服务的IOPS能力
const uint server_threads = 1;  // 每个服务的线程池数目

// 客户端参数
const uint client_total_ops = 1000;  // 每个客户发送的请求数目
const uint client_count = 100;  // 客户数目
const uint client_server_select_range = 10;
const uint client_wait_count = 1;  // 延迟启动的客户的数目
const uint client_iops_goal = 50;  // 每个客户期望的IOPS
const uint client_outstanding_ops = 100;  // 每个客户允许的等待请求
const std::chrono::seconds client_wait(10);  // 延迟启动的客户的延迟时间
```

SimpleServer的优先级队列是SimpleQueue类，SimpleQueue类调度请求的顺序是先进先出。具体实现参考该类的schedule_request()方法。


# VS快捷键

F12 : 转到定义
Ctrl + -: 让光标移动到它先前的位置
Ctrl + +: 让光标移动到下一个位置
Ctrl + Up/Down: 滚动窗口但不移动光标
