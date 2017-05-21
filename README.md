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
