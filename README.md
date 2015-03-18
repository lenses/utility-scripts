# scripts
Script to setup and run lenses app.

## Other useful scripts:

* Runs git status on every th-* directory. Run in development (e.g. lenses) directory
For Lenses:
<pre>
find . -name 'lens*' -type d -depth 1 -exec sh -c 'echo "\n \x1B[0;33m CHECKING STATUS IN {} \x1B[0m \n"' \; -exec git -C {} status \;
</pre>
For Thelma:
<pre>
find . -name 'th-*' -type d -depth 1 -exec sh -c 'echo "\n \x1B[0;33m CHECKING STATUS IN {} \x1B[0m \n"' \; -exec git -C {} status \;
</pre>

* Replace all th-* bower directories with git directories. This script is meant to be run once after bower installing all the componets. <b>(USE WITH CAUTION! It removes the existing th-* directories)</b>
<pre>
curl -u [USERNAME] -s https://api.github.com/orgs/thelmanews/repos?per_page=100 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| 
  exclude_repos = ["thelmacheer", "th-footnote","th-line-graph","th-multistep", "th-two-column","thelma-charts", "thelma", "thelma-component-demo", "thelma-components", "thelma-core", "thelma-data", "thelma-utils", "thelma-text", "thelmanews.github.io"]
  
  %x[rm -rf #{repo["name"]}]

  unless exclude_repos.include?(repo["name"])  
    %x[git clone #{repo["ssh_url"]} ]
  end
}' 
</pre>

* get all lenses repos:
<pre>
curl -s https://api.github.com/orgs/lenses/repos | grep ssh_url | grep lens- | sed s/\"ssh_url\"\://g | sed s/\"//g | sed s/,//g | xargs -I {} -n 1 git clone {}
</pre>
