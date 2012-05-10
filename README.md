# Transcode

A Resque-backed HandBrake batch DVD transcoder. Transcode is built to make it as frictionless as possible to convert DVDs to iOS compatible, high quality M4V files. Transcode will try to detect TV DVDs and attempt to split them up into episodes.

## Workflow

Transcode assumes that DVDs are ripped with [RipIt](http://thelittleappfactory.com/ripit/). Once the rip is complete, Transcode will queue the encode job.

## Installation

Resque requires redis. The easiest way to install redis on the mac is by using homebrew.

    $ brew install redis

To run transcode clone the repository:

    $ git clone git://github.com/benubois/transcode.git && cd transcode

… and use bundler to install dependencies

    $ bundle install

Rename the included config.example.yml to config.yml and add your settings. Transcode requires the path to you DVD rip directory and where to save the transcoded files. The path to the HandBrakeCLI executable can be added if it is not on your $PATH. Configure RipIt to save to the rips directory from config.yml.

Finally, run the app using:

    $ rake start

The Resque frontend will be available at [localhost:5050](http://localhost:5050)

## HandBrake Conversion Settings
Transcode uses HandBrakeCLI to transcode video from DVD to H.264 encoded m4v. The settings are the same as the High Profile option with a few additions to include forced subtitles.