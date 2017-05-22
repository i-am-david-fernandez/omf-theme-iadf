<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### iadf
> A theme for [Oh My Fish][omf-link].

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.2.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>

## Overview

The core design goal of this theme is for it to be useful for daily work. This means it must provide useful information (i.e., information that helps the user get their work done) but also that it must be non-intrusive (i.e., is not distracting and is responsive/fast).

## Install

```fish
$ omf install https://github.com/i-am-david-fernandez/omf-theme-iadf
```


## Features

* VCS state information for multiple version control systems simultaneously (git, subversion and mercurial are supported).

## Configuration

The following may be set (e.g., in `config.fish`) to override defaults:

* `fish_prompt_pwd_dir_length`
  * Parameter to the standard [`prompt_pwd`](https://fishshell.com/docs/current/commands.html#prompt_pwd) fish function.

* `theme_iadf_vcs_list`
  * List of VCSes to process. Supported vcses are `git`, `svn` and `hg`.
  * Keeping this list minimal (i.e., only including those you actually use) will help minimise prompt lag.

* `theme_iadf_vcs_colour_dirty`, `theme_iadf_vcs_colour_clean`
  * Colour of vcs name when current repo is dirty/clean.

* `theme_iadf_vcs_colour_branch`
  * Colour of the current repo's branch name.

* `theme_iadf_vcs_glyph_{untracked|missing|modified}`
  * State glyph used to indicate there are untracked/missing/modified items in the current repo.

* `theme_iadf_vcs_colour_{untracked|missing|modified}`
  * Colour of the corresponding state glyph.

e.g.

```
    ## Use two charaters per path segment in shortened present-working-directory display
    set -g fish_prompt_pwd_dir_length 2

    ## Support only git and svn
    set -g theme_iadf_vcs_list git svn

    ## Show dirty repo as red, clean as green
    set -g theme_iadf_vcs_colour_dirty "red"
    set -g theme_iadf_vcs_colour_clean "green"

    ## Show the branch name in blue
    set -g theme_iadf_vcs_colour_branch "blue"

    ## Indicate untracked files with a yellow question mark
    set -g theme_iadf_vcs_glyph_untracked "?"
    set -g theme_iadf_vcs_colour_untracked "yellow"

    ## Indicate missing files with a red exclamation mark
    set -g theme_iadf_vcs_glyph_missing "!"
    set -g theme_iadf_vcs_colour_missing "red"

    ## Indicate modified items with a green plus/minus symbol
    set -g theme_iadf_vcs_glyph_modified "±"
    set -g theme_iadf_vcs_colour_modified "green"
```


## Screenshot

<p align="center">
<img src="{{SCREENSHOT_URL}}">
</p>


## Acknowledgements/References

This theme draws inspiration, ideas and code from a number of other themes and packages, most notably

* [theme-bobthefish](https://github.com/oh-my-fish/theme-bobthefish)
   * While beautiful, I found much of this much too slow for my liking.
* [plugin-vcs](https://github.com/oh-my-fish/plugin-vcs)
   * While the abstraction is a nice idea, I found the implementation lacking in the speed department with regards to multiple external command calls to extract data. In the constrained context of a prompt, a more efficient approach is needed.


# License

[MIT][mit] © [David Fernandez][author] et [al][contributors]


[mit]:            https://opensource.org/licenses/MIT
[author]:         https://github.com/{{USER}}
[contributors]:   https://github.com/{{USER}}/theme-iadf/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
