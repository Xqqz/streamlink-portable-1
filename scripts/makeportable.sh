#!/usr/bin/env bash
# This script takes one argument, the windows arch for which to build it (win32 or amd64) and it defaults to win32

# usage: ./makeportable.sh [branch] [arch]

set -e # quit on error

branch=${1:-master}
branch=${branch%+*}
STREAMLINK_PYTHON_ARCH=${2:-win32}
STREAMLINK_PYTHON_VERSION=3.6.5
PYTHON_PLATFORM=${STREAMLINK_PYTHON_ARCH}

if [[ "${STREAMLINK_PYTHON_ARCH}" == "amd64" ]]; then
    PYTHON_PLATFORM="win_amd64"
fi

python_url="https://www.python.org/ftp/python/${STREAMLINK_PYTHON_VERSION}/python-${STREAMLINK_PYTHON_VERSION}-embed-${STREAMLINK_PYTHON_ARCH}.zip"

root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
temp_dir="${root_dir}/build/temp"
bundle_dir="${temp_dir}/streamlink"
python_dir="${bundle_dir}/python"
packages_dir="${bundle_dir}/packages"
streamlink_clone_dir="${temp_dir}/streamlink-clone"

mkdir -p "${bundle_dir}"

echo "Downloading Python ${STREAMLINK_PYTHON_VERSION} ${STREAMLINK_PYTHON_ARCH}..."
wget -q "${python_url}" -c -O "build/temp/python-${STREAMLINK_PYTHON_VERSION}-embed-${STREAMLINK_PYTHON_ARCH}.zip"

# remove any old streamlink clone
echo "Cloning streamlink from ${branch}..."
rm -rf "${streamlink_clone_dir}"
git clone -q --depth=50 --branch="${branch}" https://github.com/streamlink/streamlink.git ${streamlink_clone_dir} > /dev/null

pushd "${streamlink_clone_dir}" > /dev/null
git fetch --tags > /dev/null  # update the tags
commit=$(git rev-parse --short HEAD)

echo "Downloading Python dependencies..."
pip download --only-binary ":all:" --platform "${PYTHON_PLATFORM}" --python-version "36" --abi "cp36m" -d "${temp_dir}" "pycryptodome==3.4.3" > /dev/null
pip install --upgrade -t "${packages_dir}" "iso-639" "iso3166" "setuptools" "requests>=1.0,>=2.18.0,<3.0" "websocket-client" "PySocks!=1.5.7,>=1.5.6" "isodate" > /dev/null

# Work out the streamlink version
STREAMLINK_VERSION=$(python setup.py --version)
if [ "$branch" = "master" ]; then
    echo "Building nightly/dev version..."
    dist_dir="${root_dir}/dist/nightly"
else
    echo "Building stable version ${branch}..."
    dist_dir="${root_dir}/dist/stable"
fi

# create an sdist package to be "installed"
echo "Building streamlink sdist"
env NO_DEPS=1 python "setup.py" sdist -d "${temp_dir}" > /dev/null

popd > /dev/null

echo "Building zip file..."
unzip -o "${temp_dir}/python-${STREAMLINK_PYTHON_VERSION}-embed-${STREAMLINK_PYTHON_ARCH}.zip" -d "${python_dir}" > /dev/null
# include the Windows 10 Universal Runtime
unzip -o "${root_dir}/resources/msvcrt_${PYTHON_PLATFORM}.zip" -d "${python_dir}" > /dev/null

unzip -o "${temp_dir}/*.whl" -d "${packages_dir}" > /dev/null
#unzip -o "${temp_dir}/requests*.whl" -d "${packages_dir}" > /dev/null

tar xf "${temp_dir}/streamlink-${STREAMLINK_VERSION}.tar.gz" --strip-components 2 -C "${bundle_dir}/packages/" "streamlink-${STREAMLINK_VERSION}/src/streamlink" "streamlink-${STREAMLINK_VERSION}/src/streamlink_cli"
cp "${root_dir}/resources/streamlink-script.py" "${bundle_dir}/streamlink-script.py"
cp "${root_dir}/resources/streamlink.bat" "${bundle_dir}/streamlink.bat"
cp "${root_dir}/NOTICE" "${bundle_dir}/NOTICE.txt"

mkdir -p "$bundle_dir/rtmpdump" "$bundle_dir/ffmpeg"
cp -r "${streamlink_clone_dir}/win32/rtmpdump/"* "${bundle_dir}/rtmpdump"
cp -r "${streamlink_clone_dir}/win32/ffmpeg/"* "${bundle_dir}/ffmpeg"
cp -r "${streamlink_clone_dir}/win32/streamlinkrc" "${bundle_dir}/streamlinkrc.template"
cp -r "${streamlink_clone_dir}/win32/LICENSE.txt" "${bundle_dir}/LICENSE.txt"

# remove the rtmpdump and ffmpeg template lines
sed -i "/^rtmpdump=.*/d" "${bundle_dir}/streamlinkrc.template"
sed -i "/^ffmpeg-ffmpeg=.*/d" "${bundle_dir}/streamlinkrc.template"

pushd "${temp_dir}" > /dev/null
mkdir -p "${dist_dir}"
zip -r "${dist_dir}/streamlink-portable-${STREAMLINK_VERSION}-py${STREAMLINK_PYTHON_VERSION}-${STREAMLINK_PYTHON_ARCH}.zip" "streamlink"  > /dev/null
if [ "$branch" = "master" ]; then
    cp "${dist_dir}/streamlink-portable-${STREAMLINK_VERSION}-py${STREAMLINK_PYTHON_VERSION}-${STREAMLINK_PYTHON_ARCH}.zip" "${dist_dir}/streamlink-portable-latest-${STREAMLINK_PYTHON_ARCH}.zip"
fi
popd > /dev/null


echo "Complete: streamlink-portable-${STREAMLINK_VERSION}-py${STREAMLINK_PYTHON_VERSION}-${STREAMLINK_PYTHON_ARCH}.zip"
