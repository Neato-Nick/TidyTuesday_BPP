# TidyTuesday for BPP
## BPP and BPP alums meet for Tidy Tuesday!

Calls are on Zoom weekly, Tuesdays at 1pm (Oregon Time).
Catie Wram will host these meetings.

## Next meeting

[351028005](https://oregonstate.zoom.us/j/351028005)

## Uploading your work
Post all work to the submissions folder under whichever week you did it for.

We will practice github uploads using a common process you can contribute to community projects.

Fork this repository and make any changes, like uploading your submissions.
Then, make a pull request to merge your changes with the 'master' branch of this repository.

This tutorial is helpful:
https://blog.scottlowe.org/2015/01/27/using-fork-branch-git-workflow/

Here are the steps, pasted from the link above.
With git installed, you can do these commands in the git command-line.
* Fork (using the fork button on github)
* `git clone https://github.com/Neato-Nick/TidyTuesday_BPP.git`
* `git remote add upstream https://github.com/Neato-Nick/TidyTuesday_BPP.git`
* `git checkout -b <new branch name>`
* add files/make changes on the branch
  * `git add <file1> <file2> ... <filen>`
  * `git commit -m 'Week 1 submission'`
* `git push origin <branch name>`
* github will prompt you to make a pull request, do it

If you've never used git and are trying to avoid it all costs, Rstudio has git/github integration these days and it actually works really well in my experience.
https://happygitwithr.com/rstudio-git-github.html
In Rstudio, you can do all the steps above after forking and up until the pull request.

I used this tutorial for set-up:
http://www.geo.uzh.ch/microsite/reproducible_research/post/rr-rstudio-git/

Each week, to freshen your fork of this repository, you'll need to use two git commands.
I don't think Rstudio can do this.

You can open the git terminal from Rstudio and then do this:
Rstudio Tools -> Shell..
```
git pull upstream master
git push origin master
```

If you've been working off your own custom-named branch: delete it, sync your master branch, and make a new branch for the week
```
git checkout master
git branch -d <NAME OF YOUR DEVELOPMENT BRANCH>
git push origin master
git push --delete origin <NAME OF DEVEL BRANCH>
git pull upstream master
git push origin master
```
