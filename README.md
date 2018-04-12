# evaluator

This API can be used as a backbone for applications like Sphere Online Judge (SPOJ).

It's a Rack application that allows you to execute user submitted code safely(-ish) on your server,
capture its output and execution time.
All code is executed inside isolated docker container and system resources it's allowed to use are configurable during request.

## Setup

This API has been tested on Ubuntu 16.04. You can execute `sudo ./setup.sh` to install docker and properly setup all requirements.

This script will also prepare docker image used for code execution.

## Running API

To run the API first install required dependencies with `bundle install` and then simply execute `rackup`

## Using the API

Executing code requires two steps:
1. Requesting code execution

    First, you have to send container setup and code to be executed

    `POST http://localhost:9292/solutions`
    ```json
    {
        "language": "ruby",
        "timeout": "5",
        "memory": "20m",
        "cpus": "0.5",
        "code": "puts 'Hello evaluator'"
    }
    ```
    The request expects the following parameters:
    * `language` - command used to execute code. Currently only `ruby`, `python`, `python3` and `nodejs` are supported, but support for additional languages can be easily added to the executor script (also compiled ones)
    * `timeout` - number of second the runner will be able to execute
    * `memory` - memory assigned to the runner (ending with b, k, m or g). Keep in mind that interpreters use some memory for themselves so keep this limit a bit higher than you need for code execution
    * `cpus` - how many cpus should be available to the docker container (can be any decimal - if you set it to `0.1` you *should* be able to execute 10 container on a single core)
    * `code` - string containing code to be executed
    
    Response should have status 200 and an `id` in body
    ```json
    {
        "id": "7073cae7-a745-4a89-82d6-bcdb4ac1199e"
    }
    ```

2. Getting execution results

    After requesting code execution you can start polling for execution results.
    
    `GET http://localhost:9292/solutions/7073cae7-a745-4a89-82d6-bcdb4ac1199e`
    
    If the code is still running you'll get
    ```json
    {
        "ready": false
    }
    ```
    Once it's finished executing (or has been killed due to timeout or exceeding available resources) you'll get
    ```json
    {
        "ready": true,
        "output": "Hello evaluator",
        "errors": "",
        "time": 108
    }
    ```
    `time` is code execution time (with interpreter startup) in milliseconds
