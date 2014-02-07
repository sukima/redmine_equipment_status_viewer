# Contributing

If you'd like to contribute to the project, you can use the usual github pull-request flow:

1. Fork the project
2. Make your change/addition, preferably in a separate branch.
3. Test the new behaviour and make sure all existing tests pass (optional, see below for more information).
4. Issue a pull request with a description of your feature/bugfix.

## Testing

This project contains tests but the coverage is so bad it is hardly worth it. I
would love to place better tests at the top of the TODO list.

Tests are part of the Redmine project and need to be ran from within a complete
Redmine project which has this plugin either installed or sym-link.

TODO: Add more detail

    $ rake test:plugins
