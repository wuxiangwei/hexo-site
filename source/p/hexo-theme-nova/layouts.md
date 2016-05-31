title: Layouts
layout: project
title2: hexo-theme-nova.userguide.layouts
---
The theme provided three layouts to demonstrate the page.

 1. `post` for blog
 2. `project` for github project
 3. `page` for other pages

## layouts ##
### post
Similar to most hexo theme, nova has index, archive, widgets layout. The difference is nova rewrite archive list helpers and provided two paginator helpers.

### project
Project layout is aimed to demonstrate the github projects info. For project layout, a `gh` front-matter is nessary in your page.

The projects sidebar is configurated in <var>_data</var>/<var>projects.yml</var>

### page

The default layout of other pages.

A `type` front-matter is used to mark special pages.

- categories: Categories page
- donates: Donate list page.

### other
- comment: Page comment, default is uyan comment
- share: Baidu share component
- analytics: Baidu analytics component
- donate: page donate component

## Front-matter
### toc
Show table of contents or not, if not set, the default value is:
 - post layout: false
 - project layout: true
 - page layout: true
 
### title2
The internationalization title key, will be translated with `__(title2)`

Example
```yml
title: Downloads
title2: project.download
---
```

The page title will be the output of `__(project.download)`

### type
`type` front-matter only used in page layout.

### gh
- gh.user: the github user, default is the user in theme <var>_config.yml</var>
- gh.repo: the github repo, default is fetched from url
- gh.type 
    - get_repos: The `gh_repos()` helper will invoked to get repositories from github. 
    - get_contents: The `gh_repo_contents()` helper will be invoked to get markdown file under repository.
    <var>gh.path</var> to indicate the concrete file on github, default is **README.md**
    <var>gh.ref</var> to indicate the branch on github, default is **master**
    - get_releases: The `gh_repo_releases()` helper will be invoked to get releases under repository.
    



