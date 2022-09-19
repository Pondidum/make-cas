# Make CAS
*Content based changed detection form [Make]*

## Setup

```shell
export "AWS_ACCESS_KEY_ID=minio"
export "AWS_SECRET_ACCESS_KEY=password"
export "CAS_REMOTE=./build/remote_s3.sh"
export "CAS_S3_BUCKET_PATH=makestate/cas-demo/"
export "CAS_READ_ONLY=0"  # set to 1 to only read from remote caches
export "CAS_VERBOSE=1"    # don't set, or set to 0 to silence the output

docker-compose up -d
aws --endpoint-url http://localhost:9000 s3 mb s3://makestate
```

## Testing

Run an initial build:

```shell
$ git clean -dxf
$ make build
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Fetching remote state to .state/c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Storing state from .state/c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256
  977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256: Fetching remote state to .state/977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256
  977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256: Storing state from .state/977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256
  ==> Building
  ==> Done
  Storing dist/index.js
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Storing artifact dist/index.js
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Storing state from .state/c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256
$ cat dist/index.js
  compiled at la 17.9.2022 13.16.48 +0300
```

You can now clean the repo and build again:

```shell
$ git clean -dxf
$ make build
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Fetching remote state to .state/c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Fetching dist/index.js
  977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256: Fetching remote state to .state/977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256
  make: Nothing to be done for 'build'.
$ cat dist/index.js
  compiled at la 17.9.2022 13.16.48 +0300
```

And check that the output file (`dist/index.js`) exists again, and contains the date from the first build.

You can prove that changing a file date does nothing:


```shell
$ touch src/index.ts
$ make build
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Fetching remote state to .state/c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256
  c2bac686e507434398d9bf4e33f63f275dfd3bfecfe851d698f8f17672eeccbe.sha256: Fetching dist/index.js
  977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256: Fetching remote state to .state/977e50e9421f0a2749587de6a887ba63f2ddf9109d27ab7cae895a6664b2711a.sha256
  make: Nothing to be done for 'build'.
$ cat dist/index.js
  compiled at la 17.9.2022 13.16.48 +0300
```

## Configuration


### `CAS_VERBOSE`
Default: `0`\
Print to the console what is is happening.  `0` or `1`.

### `CAS_READ_ONLY`
Default: `1`\
If `CAS_REMOTE` is specified, only read from it, no writing.  `0` or `1`

### `CAS_REMOTE`
Default: unset\
Specify the path to a remote storage API e.g. `./build/remote_s3.sh`.

### `CAS_S3_BUCKET_PATH`
Default: unset\
Specify the name of the s3 bucket, and optionally a path prefix.  e.g. `some-bucket` or `some-bucket/some/path/prefix`

### `CAS_S3_CMD`
Default: `aws --endpoint-url http://localhost:9000 s3`\
Override the S3 command.  For a real S3 bucket you should set it to `aws s3`

### `CAS_STORE_PATH`
Default: `.state`\
When in the repository to write the hash files to and from.





[make]: https://www.gnu.org/software/make/