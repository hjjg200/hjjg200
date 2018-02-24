# s3-browser

PHP script that accesses(readonly) AWS S3 and sprays tables of objects.

## Details

### Given S3 Permissions

The following permissions are given to the user I am planning to use the script with.

- HeadBucket, ListAllMyBuckets, ListBucket, ListObjects, GetObject

### Concept

1. The PHP script acquires a path from `$_GET['p']`.<br>
   The path is formatted as `/{$bucket-name}/{$path-within-bucket}`.<br>
   -> e.g., `/example-s3-bucket/path/to/file.txt`<br>
   -> in regex, `/^\/(?:[^\0]*[^\/])?$/`<sup>[1](#d-1)</sup>
1. Checks where the path resolves to and does as [Path Type Behavior](#path-type-behavior).

<a name='path-type-behavior'></a>
### Path Type Behavior

#### Root(`/`)
- Echoes `<table>` of all the buckets.
- `<tr>` has `href` attribute and its value is the full path to the bucket<br>
  -> e.g., `<tr href='/example-s3'...`
- Name is the only table header.
- `<tr>` of inaccesible buckets have `denied` as its class.<br>
  -> e.g., `<tr class='denied'...`

#### Directory(`/example-s3/shared`)
- Echoes `<table>` of the files in the directory.
- `<tr>` has `href` attribute and its value is the full path to the object<br>
  -> e.g., `<tr href='/example-s3/shared/photo'...`
- The table headers are name, size<sup>[2](#d-2)</sup>, and MIME type.
- `<tr>` of inaccessible objects have `denied` as its class.<br>
  -> e.g., `<tr class='denied'...`

#### Every File(`/example-s3/a.txt`)
- `$_GET['d'] == 0` : Refer to the list below
- `$_GET['d'] == 1` : Force downloads the file in chunks<sup>[4](#d-4)</sup>; this applies to every file type

#### Text File
- Echoes the content in chunks<sup>[4](#d-4)</sup>.

#### Video or Audio<sup>[3](#d-3)</sup>
- Streams<sup>[5](#d-5)</sup> the file

#### Nothing or Permission Denied
- 404 Not Found

### Coding Style

- **Object-Oriented** : Namely, `class s3_browser`, `class bucket`, `class object`, `$object->stream()`, `$object->size()`, etc. And refer to the [Script File Hierarchy](#script-file-hierarchy)
- **Within Namespace** : Within `anton\s3_browser`

<a name='script-file-hierarchy'></a>
### Script File Hierarchy
Script file hierarchy should be like:

```
/
/index.php
/lib
/lib/aws...
/config
/config/config.php
/class
/class/s3_browser.php
/class/bucket.php
/class/object.php
...
```

1. Only the `index.php` will be available to the public.
2. Other files such as class files and config files will not be accessible for the public.
3. Files other than `index.php` should be under a directory.

### Authentication

1. `config.php` contains arrays of Access Key ID, Secret Access Key.

```php
$auth = array(
   "username1" => array(
      "access" => "...",
      "secret" => "..."
   ),
   "username2" => array(
      ...
   )
   ...
)
```

2. And the PHP script acquires the currently authenticated username with `$_SERVER['PHP_AUTH_USER']`.
3. The PHP script retrieves the access information of the user.

### Error Handling

In case of an error, it depends on the variable `$debug`[6](#d-6) :

- `$debug === FALSE` : HTML response 500
- `$debug === TRUE` : sprays the error message

### Further Details

1. <a name='d-1'></a> The path must start with a slash(`/`) and paths other than root(`/`) must not end with a slash(`/`)
2. <a name='d-2'></a> Size is in Bytes. Sizes of inaccessible files are displayed as `-`(dash).
3. <a name='d-3'></a> `video/mp4`, `video/x-matroska`, `audio/aac`, etc.
4. <a name='d-4'></a> Echoes and flushes the content in chunks
5. <a name='d-5'></a> Streams the file with the appropriate MIME type so that applications like VLC can stream them.
6. <a name='d-6'></a> A private variable of `class s3_browser`

### As for HTML and CSS

I will write the HTML template and CSS myself. Therefore, the only thing PHP should do is spraying the `<table>`.
