# scripts
Script to setup and run lenses app.

## Instructios to use lenses-setup.sh script.

### Setup:
1. Clone or download/unzip the repo
2. Open terminal and go to the repo directory you just created (e.g. `cd ~/Desktop/utility-scripts`)
3. Run `./lenes-setup.sh setup`. The clones the UI, installs bower dependencies and runs python SimpleHTTPServer.
4. Open browser and go to `http://localhost:8008/lenses-freeform/demo.html` (or `http://localhost:8008/lens-compose/demo.html` for linear version)

**NOTE** Script installs the files in `HOME_DIR/Documents/lenses`. If that directory exists it backs up that directory to `lenses.bck`. If both exist setup scrips exits without installing. Remove either directory and run the script again.

### Modifying setup scripts:
There are 4 variables on top of lenses-setup.sh:
```
ROOT=~/Documents
HOME_DIR="$ROOT/lenses"
COMPOSER="lenses-freeform" #lens-composer
GIT_ORG="lenses"  #lenses
```

* `ROOT` is where the lenses direcotry will be created. You can change it to `~/Desktop` or anything else (`~` means your home directory)
* `HOME_DIR` is the name of directory. Keep the `$ROOT/` part but you can modify `lenses` to any other name.
* `COMPOSER` is the UI version you want: use `lenses-freeform` for the freeform version or `lens-composer` for linear.
* `GIT_ORG` (Advanced) is the github user/organization which has the composer code. If you fork `lenses-freeform` or `lens-composer` you can change that to your github account.

### Other lenses-setup.sh tasks:
* `lenses-setup.sh run-server` runs python server. If you have lenses setup but just want to run http server use this (similar to `python -m SimpleHTTPServer 8008`)
* `lenses-setup.sh kill-server` Shuts down the server.
* `lenses-setup.sh update` updates your code base. **IMPORTANT NOTE** If you have modified the code of UI or one of the already existing components runing update scripts **overwrites** your changes. If you have only created a new component in a new directory in `lenses` folder it will be safe.

#### Comon Problems:
* If by running `./lenses-setup.sh setup` you get `Permission denied` error try `chmod u+x lenses-setup.sh` to give execute permission to script. You might need to do `sudo chmod u+x lenses-setup.sh` if former command didn't work (though it is a red flag that there is a problem on your computer setup)

**For any other problems please file an [issue](https://github.com/lenses/utility-scripts/issues)**


## Other useful scripts:

* Runs git status on every component directory (e.g. lens-*). Run inside development (e.g. lenses) directory

For Lenses:
<pre>
find . -name 'lens*' -type d -depth 1 -exec sh -c 'echo "\n \x1B[0;33m CHECKING STATUS IN {} \x1B[0m \n"' \; -exec git -C {} status \;
</pre>
For Thelma:
<pre>
find . -name 'th-*' -type d -depth 1 -exec sh -c 'echo "\n \x1B[0;33m CHECKING STATUS IN {} \x1B[0m \n"' \; -exec git -C {} status \;
</pre>

* Replace all lens-* bower directories with git directories. This script is meant to be run once after bower installing all the componets. <b>(USE WITH CAUTION! It removes the existing lens-* directories)</b>
<pre>
curl -u [USERNAME] -s https://api.github.com/orgs/lenses/repos?per_page=100 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| 
  exclude_repos = ["thelmacheer", "th-footnote","th-line-graph","th-multistep", "th-two-column","thelma-charts", "thelma", "thelma-component-demo", "thelma-components", "thelma-core", "thelma-data", "thelma-utils", "thelma-text", "thelmanews.github.io"]
  
  %x[rm -rf #{repo["name"]}]

  unless exclude_repos.include?(repo["name"])  
    %x[git clone #{repo["ssh_url"]} ]
  end
}' 
</pre>

* Clone all lenses repos:
<pre>
curl -s https://api.github.com/orgs/lenses/repos?per_page=100 | grep ssh_url | grep lens- | sed s/\"ssh_url\"\://g | sed s/\"//g | sed s/,//g | xargs -I {} -n 1 git clone {}
</pre>
