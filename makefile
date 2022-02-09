ifndef VERBOSE
.SILENT:
endif

test: all
	dart pub global activate coverage
	dart test --chain-stack-traces --coverage=coverage
	format_coverage --packages=.packages --report-on=lib --lcov -o coverage/lcov.info -i coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

dev-test:
	dart test --chain-stack-traces --coverage=coverage
	format_coverage --packages=.packages --report-on=lib --lcov -o coverage/lcov.info -i coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

all: deps
	dart fix --apply
	dart format .
	# dart analyze --fatal-infos
	dart run build_runner build --delete-conflicting-outputs

deps: clean
	dart pub get >>/dev/null

clean:
	rm -rf doc coverage

docs:
	dartdoc

analyze:
	dart pub global activate pana
	pana --no-warning . >pana.md

act-build:
	act --bind --rm --directory "$(PWD)" --env-file "$(PWD)/.act/.env" --eventpath "$(PWD)/.act/push_main.json" --container-architecture linux/arm64
