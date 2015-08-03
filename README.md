Erector to Fortitude
----

Converts Erector views to Fortitude syntax. In practice, this means assigning IDs and classes in the options hash: https://github.com/ageweke/fortitude/blob/master/README-erector.md#what-doesnt-it-support

## Usage

```
bin/erector_to_fortitude path/to/views
```

## Known issues

- Can't transform the contents of a proc that's the value of a hash (!??)
