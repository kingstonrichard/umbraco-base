# Umbraco Base

This repo contains a Powershell script that creates a new .NET Core Umbraco solution populated with a set of base artefacts, i.e. document types, data types, templates, etc. so that you don't have to start from scratch.

The included uSync folder contains those pre-written artefacts. The script scaffolds a fresh Umbraco instance around them, such that you can simply import them using uSync once you have it running.

The primary purpose of this repo is to maintain those artefacts, hence there are no Umbraco files here. The .gitignore file is specifically set up to only capture the uSync folder, i.e. the exported artefacts.

The script gets the latest version of Umbraco at the time you run it and adds the latest versions of the Umbraco.Forms and uSync packages from NuGet to it. This ensures we're not storing 'old' versions of Umbraco over time. Running a 'uSync Import' then brings in all the artefacts.

After running the script, you'll have a folder structure like this:

```
src\
|-- Umbraco\
|--|-- bin\
|--|-- obj\
|--|-- umbraco\
|--|-- uSync\
|--|--|-- vX (where X is a version number)
|--|-- Views\
|--|-- wwwroot\
|--|-- Umbraco.csproj
.gitignore
_install.ps1
<folder-name>.sln
```

You can then run the project, configure Umbraco, and then run a uSync Import from the Settings screen of the Umbraco back end.

# Get Started

Clone the repo into a folder of your choice and run the script:

```
git clone --depth 1 https://github.com/kingstonrichard/umbraco-base MySolution
cd MySolution
.\install.ps1
```

The script will use the name of your folder to create an SLN file with the same name. It will then create the Umbraco project, add the NuGet packages for Umbraco.Forms and uSync and after some tidying up, will build the solution.

When the script has finished running, it will tidy up by:

- Reinitialising the git repo so you have a fresh one
- Deleting itself so that it doesn't clutter up your solution folder/files

You can now go ahead and open this solution in Visual Studio or Visual Studio Code.

If you're using Visual Studio Code, you'll need to use the command palette to generate new build assets (effectively creates the .vscode folder with the launch.json and tasks.json files in it - you need these to run and debug the project).

# GIT and initial commit

When you open the solution you'll notice that all files are ready to be committed to the git repo. The repo has no remote origin at this point and no branches. Let's fix that:

```
git branch -m main
git add -A
git commit -m 'Initial commit'
git remote add origin MyRemoteRepoUrl
git push -u origin main
```

# Next steps

As you work within the Umbraco UI to create your new website, or in your favourite IDE, note that nothing will be tracked by GIT. GIT tracks your uSync exports only! So periodically run a 'uSync Export' of 'everything' and push those to your repository.

The beauty in this approach is that you're only ever storing the specifics of your website and nothing relating to Umbraco itself - so you can always redeploy to the latest version of Umbraco without issue.
