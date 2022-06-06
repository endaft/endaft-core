ifndef VERBOSE
.SILENT:
endif

test: all
	dart pub global activate coverage
	dart test --chain-stack-traces --coverage=coverage
	format_coverage --report-on=lib --lcov -o coverage/lcov.info -i coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

dev-test: clean dev-gen
	dart test --chain-stack-traces --coverage=./coverage
	format_coverage --report-on=lib --lcov -o ./coverage/lcov.info -i coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

dev-gen:
	dart run build_runner build --delete-conflicting-outputs

all: deps
	dart fix --apply >>/dev/null
	dart format . >>/dev/null
	dart analyze --fatal-infos
	dart run build_runner build --delete-conflicting-outputs >>/dev/null

deps: clean
	dart pub get >>/dev/null

clean:
	rm -rf doc
	rm -rf coverage

docs:
	dartdoc

analyze:
	dart pub global activate pana
	pana --no-warning . >pana.md

act-build:
	act --bind --rm --directory "$(PWD)" --env-file "$(PWD)/.act/.env" --eventpath "$(PWD)/.act/push_main.json" --container-architecture linux/arm64

default: all
