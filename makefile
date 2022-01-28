ifndef VERBOSE
.SILENT:
endif

all: clean deps
	dart fix --apply
	dart format .
	dart analyze --fatal-infos
	dart run build_runner build --delete-conflicting-outputs

deps: clean
	dart pub get

clean:
	rm -rf .dart_tool doc .packages pubspec.lock coverage

docs:
	dartdoc
