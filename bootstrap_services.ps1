$serviceFolder = 'c:\CanErectors\Services'
$bootStrapFolder = "$serviceFolder\bootstrap"

git clone git@github.com:canerectors/CanErectors.Services.Bootstrap $bootStrapFolder

pushd $bootStrapFolder

./start.bat