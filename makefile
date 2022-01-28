ifndef VERBOSE
.SILENT:
endif

test: all
	dart pub global activate coverage
	dart test --chain-stack-traces --coverage=coverage
	format_coverage --packages=.packages --report-on=lib --lcov -o coverage/lcov.info -i coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

all: clean deps
	dart fix --apply
	dart format .
	# dart analyze --fatal-infos
	dart run build_runner build --delete-conflicting-outputs

deps: clean
	dart pub get >>/dev/null

clean:
	rm -rf .dart_tool doc .packages pubspec.lock coverage

docs:
	dartdoc