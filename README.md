## A simple pipeline to generate website from Jupyter notebooks

Copyright 2016 Gao Wang

### Step 0: install dependencies

```
pip install sos bs4 
```

### Step 1: install `jnbinder`
```bash
wget https://github.com/vatlab/jnbinder/archive/master.zip
unzip -p master.zip jnbinder-master/release > release
chmod +x release
./release setup-jnbinder
```

### Step 2: create project notebooks under various folders
Or, create empty folders and move your existing notebooks into them.

### Step 3: edit `config.yml`
See the template `config.yml` file in this repo. Particularly, configure `include_dir` to include the folders from Step 2.

### Step 4: build website
```
./release -j 10
```
Or, when things go wrong (pages not updated as expected).

```
./release -s force -j 10
```
where `-j 10` means running 10 conversion commands in parallel -- useful when there is a lot of notebooks to bind.
### Mics: upgrade `jnbinder`
```
./release upgrade-jnbinder
```

For first time users we have created an annotated demonstration: https://github.com/stephenslab/ipynb-website 

**Notice that the demonstration site only shows some aspects of the software**.
You are welcome to download the demonstration to adapt for your project. 
You are also encouraged to play with configurations in
[`config.yml`](https://github.com/vatlab/jnbinder/blob/master/config.yml)
to customize your site or the release workflow.

The software is intented for my personal use but I'm happy to help if you request a feature or report a bug 
(it is not fully documented so do not worry about requesting for features that already exist!).

Here are more examples of generated research websites:

* https://gaow.github.io/mvarbvs
