import sys
import os

def deploy():
    script_path = os.path.dirname(os.path.realpath(__file__))

    os.system('flutter pub run flutter_launcher_icons:main -f "' + script_path + '/config.yaml"')
    os.system('flutter pub run flutter_native_splash:create --path="' + script_path + '/config.yaml"')
    build_command = 'flutter build ' + sys.argv[1]
    if sys.argv[2] == 'release':
        build_command += ' --release'
    os.system(build_command)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print('Usage: "./deploy.sh <apk/appbundle/ios> <dev/release>"')
        exit(-1)
    if sys.argv[1] != 'apk' and sys.argv[1] != 'appbundle' and sys.argv[1] != 'ios':
        print('Usage: "./deploy.sh <apk/appbundle/ios> <dev/release>"')
        exit(-1)
    if sys.argv[2] != 'dev' and sys.argv[2] != 'release':
        print('Usage: "./deploy.sh <apk/appbundle/ios> <dev/release>"')
        exit(-1)
    deploy()