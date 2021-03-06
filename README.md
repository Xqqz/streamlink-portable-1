# Streamlink Portable
A script to build a portable version of Streamlink for Windows.

The portable zip files are build from the master branch of [streamlink/streamlink](https://github.com/streamlink/streamlink) and come bundled with Python 3.5.4. There is a 32 bit and a 64 bit version available for 32 bit Windows and 64 bit Windows (if in doubt use the 32 bit version).

The latest versions of the portable zips can be downloaded here:
- [streamlink-portable-latest-win32.zip](https://dl.bintray.com/beardypig/streamlink-portable/streamlink-portable-latest-win32.zip)
- [streamlink-portable-latest-amd64.zip](https://dl.bintray.com/beardypig/streamlink-portable/streamlink-portable-latest-amd64.zip)

A stable version is also available, based on the `0.14.2` tag of streamlink:
- [streamlink-portable-0.14.2-py3.6.5-win32.zip](https://github.com/beardypig/streamlink-portable/releases/download/0.14.2+1/streamlink-portable-0.14.2-py3.6.5-win32.zip)
- [streamlink-portable-0.14.2-py3.6.5-amd64.zip](https://github.com/beardypig/streamlink-portable/releases/download/0.14.2+1/streamlink-portable-0.14.2-py3.6.5-amd64.zip)

To install simply unzip the zip file.

A `streamlink.bat` is included in the zip file so that you can easily execute `streamlink`.

The `streamlinkrc` file is read from the same directory as the `streamlink.bat` and is created when you first execute `streamlink.bat`, however it will not overwrite any existing config file so it an be editted and the changes not lost when updating.

## Building the zip files under Linux/macOS

NB. `sed` must be `gnu-sed`

- Clone this repo and execute the `scripts/makeportable.sh` script.


## Changelog

### 2018-08-01

* Re-release stable `0.14.2` as `0.14.2+1`, with fixed `--version`.

### 2018-07-12

* Release stable `0.14.2`.

### 2018-06-06

* Release stable `0.13.0`.
* Update Python to 3.6.5.

### 2018-06-04

* Add `isodate` module.

### 2018-05-09

* Release stable `0.12.1`.

### 2018-03-01

* Release stable `0.10.0`.

### 2017-09-14

* Release stable `0.8.1`.
* Resolved issue with missing `websocket` and `PySocks` modules.
* Update to Python 3.5.4.

### 2017-07-05

 * Release stable `0.7.0`.
 * Resolved issue with missing `urllib3` module.

### 2017-05-11

 * Release stable `0.6.0`.
 * Moved the nightly builds to Bintray.

### 2017-03-29

 * Release stable `0.5.0`, lagged behind the official release.

### 2017-02-12

 * Release stable `0.3.2`.

### 2017-02-03

 * Added build trigger script that is running every 5 minutes to trigger a travis build.
 * Added stable build based on tags.
 * Released stable `0.3.1`.

### 2017-01-27

 * Fixed bug with ffmpeg/rtmpdump paths being set on the command line.
 * The batch script doesn't change directory any more
 * Added iso3166 and iso-639 packages

### 2017-01-11

 * Updated to include ffmpeg.
