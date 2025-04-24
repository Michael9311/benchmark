# Rails Benchmark Project Commands & Conventions

## Build & Run Commands
- Test: `bin/rails test` (run all tests)
- Test single file: `bin/rails test test/path/to/file_test.rb`
- Test specific test: `bin/rails test test/path/to/file_test.rb:LINE_NUMBER` 
- Lint: `bin/rubocop` (checks code style)
- Security scan: `bin/brakeman` (checks for vulnerabilities)
- Run server: `bin/rails server` or `bin/dev`
- Setup development: `bin/setup`

## Code Style
- Follows [Rails Omakase Style Guide](https://github.com/rails/rubocop-rails-omakase)
- Uses 2 spaces for indentation
- Snake_case for variables and methods
- CamelCase for classes and modules
- Prefer Ruby 3 pattern matching where appropriate
- Use double quotes for strings by default
- Organize model concerns in separate files
- Keep controllers thin, move logic to service objects/models
- Follow REST conventions for controllers
- Use fixtures for test data

## Error Handling
- Use exceptions for exceptional conditions
- Validate all input at boundaries
- Log errors with appropriate context