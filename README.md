# Transcode

A Resque-backed HandBrake batch DVD transcoder. Transcode is built to make it as frictionless as possible to convert DVDs to iOS compatible, high quality M4V files. If transcode will also detect TV DVDs and attempt to split them up into episodes.

## Workflow

Transcode assumes that DVDs are ripped with [RipIt](http://thelittleappfactory.com/ripit/). Configure RipIt to put movies into the same directory that transcode watches. Once the rip is complete, transcode will queue the encode job.

## Installation

Resque requires redis. The easiest way to install redis on the mac is by using homebrew.

    $ brew install redis

Then to run transcode clone the repository:

    $ git clone git://github.com/benubois/transcode.git && cd transcode

Then use bundler to install dependencies

    $ bundle install

Next add your settings. Transcode requires the paths to you DVD rip directory, a path for where to save the transcoded files and the path to the HandBrakeCLI executable if it is not on your $PATH. Rename the included config.example.yml to config.yml and add your settings.

Finally, run the app using:

    $ rake start

The Resque frontend will be available at [localhost:5050](http://localhost:5050)

## HandBrake Conversion Settings
Transcode uses HandBrakeCLI to transcode video from DVD to H.264 encoded m4v. The settings are the same as the High Profile option with a few additions to include forced subtitles.