# Creating Recipes for Other Chefs

![](assets/title_slide.png)

## Overview
1) Mise En Place
2) Set Up Equipment
3) Get Ingredients
4) Create a Shopping List
5) Create Recipe Directions
6) Make Dish
7) Taste Test
8) Serve to Other Chefs

## 1) Mise En Place
- DockerHub Account [https://hub.docker.com/signup](https://hub.docker.com/signup)
- Docker installed 
  - Mac [https://hub.docker.com/editions/community/docker-ce-desktop-mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)
  - Windows [https://hub.docker.com/editions/community/docker-ce-desktop-windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- GitHub Account [https://github.com/join?source=header-home](https://github.com/join?source=header-home)

## 2) Set Up Equipment
- Fork repo [https://github.com/bryan-nice/creating-recipes-for-other-chefs.git](https://github.com/bryan-nice/creating-recipes-for-other-chefs.git)
- Create DockerHub Repo and Link forked GitHub Repo to it

## 3) Get Ingredients
Clone repo forked repo

```bash
git clone https://github.com/bryan-nice/creating-recipes-for-other-chefs.git 
```

## 4) Create Shopping List
  - Open the file [nedocsRandomForestForecast.R](R-Model/nedocsRandomForestForecast.R)
  - At the top of the file add `#!/usr/bin/env Rscript`. This will enable the bash interpreter to use the correct kernel so it can be executed like an app. 
  - Look for the line where the variable `packages` exists and take note of the packages required for this model to function.
  - Let's inspect the R file to understand how data is following in and out of the model process.

## 5) Create Recipe Directions 
  - Open `Dockerfile` and add the list of required pacakages to the line with `ENV R_PACKAGE`. (Should look like `ENV R_PACKAGE "'a','b','c'"`)
  - Let's inspect the `Dockerfile` to understand the instructions.
  - Save and close `Dockerfile`


## 6) Make Dish
Execute docker build command to create the image locally.

```bash
docker build --tag nedocs .
```

## 7) Taste Test
Test the container with the example data set to verify everything works correctly.
 
```bash
docker run --rm -it -v ${PWD}/examples:/examples nedocs \
    --r-script /r-files/nedocsRandomForestForecast.R \
    --input-data-file /examples/nedocs_dataset.csv \
    --output-data-file /examples/nedocs_output.csv
```

## 8) Serve to Other Chefs
Commit and push completed recipe to GitHub repo.

```bash
git add
git commit -m “finish my first recipe for a chef”
git push
```

After check the GitHub repo to verify the `Dockerfile` exists. Finally, check DockerHub to make sure the build process was triggered.
