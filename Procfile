web:            bundle exec thin start -p 5050
watch:          bundle exec rake --trace watch
progress:       bundle exec rake --trace progress
worker_scan:    env QUEUE=transcode_scan bundle exec rake resque:work
worker_convert: env QUEUE=transcode_convert bundle exec rake resque:work
worker_delete:  env QUEUE=transcode_delete bundle exec rake resque:work
