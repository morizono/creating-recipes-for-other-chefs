# Creating Recipes for Other Chefs

![](assets/title_slide.png)

## Overview
1) Get Ingredients
2) Set Up Equipment
3) Create a Shopping List
4) Create Recipe Directions
5) Make Dish
6) Taste Test
7) Serve to Other Chefs

## 1) Mise En Place
- DockerHub Account [https://hub.docker.com/signup](https://hub.docker.com/signup)
- Docker installed 
  - Mac [https://hub.docker.com/editions/community/docker-ce-desktop-mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)
  - Windows [https://hub.docker.com/editions/community/docker-ce-desktop-windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- GitHub Account [https://github.com/join?source=header-home](https://github.com/join?source=header-home)

## 2) Set Up Equipment
- Fork repo https://github.com/bryan-nice/creating-recipes-for-other-chefs.git
- Create DockerHub Repo and Link forked GitHub Repo to it

## 3) Get Ingredients
Clone repo forked repo

```bash
git clone https://github.com/bryan-nice/creating-recipes-for-other-chefs.git 
```

## 4) Create Shopping List
- Open Model Code
  - Identify Libraries
  - How data is inputted
  - How data is outputted

## 5) Create Recipe Directions 
- Create a DockerFile

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
