# CloudCannon | i18n config merge

The goal of this peace of code is to help you to configure your Jekyll Website into [CloudCannon](https://cloudcannon.com/) Headless CMS Platform.


## PROBLEM

1. When you are using [jekyll-multiple-languages-plugin](https://github.com/kurtsson/jekyll-multiple-languages-plugin) on your pages the build process will be performed for each language, if you configure into _config.yml using `exclude_from_localizations: ["_cloudcannon"]` together [cloudcannon-jekyll](https://github.com/CloudCannon/cloudcannon-jekyll) plugin to automatic generate configuration, the last build will override with you configuration;
2. To have all configuration we cant set `exclude_from_localizations: ["_cloudcannon"]` and the folder `_cloudcannon/info.json` will be into `_site/[lang]/_cloudcannon/info.json`, will be into the language folder and the platform needs in the root folder;


## SOLUTION

[extending-your-build-process-with-hooks](https://cloudcannon.com/documentation/articles/extending-your-build-process-with-hooks/) we can configure the `postbuild` step, on this moment is where the out code work!
Using `postbuild` our code will be get all  `_site/[lang]/_cloudcannon/info.json` files and merge in a unic file on the project root folder  `_site/_cloudcannon/info.json`.


## EASY TO USE

In the first moment we will use the self cloudcannon structure.

``` bash
mkdir -p .cloudcannon/i18n-config-merge
touch .cloudcannon/i18n-config-merge/index.rb
```

Inside `.cloudcannon/postbuild` file we will write:

``` bash
echo  CUSTOM postbuild configuration'
ruby .cloudcannon/i18n-config-merge/index.rb
```

To test the automation just perform the command:

``` bash
source .cloudcannon/postbuild
```

If all right, the `_site/_cloudcannon/info.json` will be success merged!


### IMPORTANT LINKS

- [jekyll-multiple-languages-plugin](https://github.com/kurtsson/jekyll-multiple-languages-plugin)
- [cloudcannon-jekyll](https://github.com/CloudCannon/cloudcannon-jekyll)
- [extending-your-build-process-with-hooks](https://cloudcannon.com/documentation/articles/extending-your-build-process-with-hooks/)
- [deep merge using ruby](https://www.jvt.me/posts/2019/09/07/ruby-override-merge-nested-array-hash/)