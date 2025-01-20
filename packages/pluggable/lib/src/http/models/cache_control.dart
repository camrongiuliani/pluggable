class CacheControl {
  final int? maxAge;
  final int? sMaxAge;
  final bool noCache;
  final bool noStore;
  final bool mustRevalidate;
  final bool proxyRevalidate;
  final bool noTransform;
  final bool public;
  final bool private;

  CacheControl({
    this.maxAge,
    this.sMaxAge,
    this.noCache = false,
    this.noStore = false,
    this.mustRevalidate = false,
    this.proxyRevalidate = false,
    this.noTransform = false,
    this.public = false,
    this.private = false,
  });

  // Convert the CacheControl object to a string
  @override
  String toString() {
    List<String> directives = [];

    if (maxAge != null) directives.add('max-age=$maxAge');
    if (sMaxAge != null) directives.add('s-maxage=$sMaxAge');
    if (noCache) directives.add('no-cache');
    if (noStore) directives.add('no-store');
    if (mustRevalidate) directives.add('must-revalidate');
    if (proxyRevalidate) directives.add('proxy-revalidate');
    if (noTransform) directives.add('no-transform');
    if (public) directives.add('public');
    if (private) directives.add('private');

    return directives.join(', ');
  }

  // Parse a Cache-Control header string and return a CacheControl object
  factory CacheControl.parse(String header) {
    Map<String, String> directives = {};

    for (var directive in header.split(', ')) {
      var parts = directive.split('=');
      if (parts.length == 2) {
        directives[parts[0]] = parts[1];
      } else {
        directives[parts[0]] = 'true';
      }
    }

    return CacheControl(
      maxAge: directives.containsKey('max-age')
          ? int.tryParse(directives['max-age']!)
          : null,
      sMaxAge: directives.containsKey('s-maxage')
          ? int.tryParse(directives['s-maxage']!)
          : null,
      noCache: directives.containsKey('no-cache'),
      noStore: directives.containsKey('no-store'),
      mustRevalidate: directives.containsKey('must-revalidate'),
      proxyRevalidate: directives.containsKey('proxy-revalidate'),
      noTransform: directives.containsKey('no-transform'),
      public: directives.containsKey('public'),
      private: directives.containsKey('private'),
    );
  }

  // Create a CacheControl object from a map
  factory CacheControl.fromMap(Map<String, dynamic> map) {
    return CacheControl(
      maxAge: map['max-age'] as int?,
      sMaxAge: map['s-maxage'] as int?,
      noCache: map['no-cache'] as bool? ?? false,
      noStore: map['no-store'] as bool? ?? false,
      mustRevalidate: map['must-revalidate'] as bool? ?? false,
      proxyRevalidate: map['proxy-revalidate'] as bool? ?? false,
      noTransform: map['no-transform'] as bool? ?? false,
      public: map['public'] as bool? ?? false,
      private: map['private'] as bool? ?? false,
    );
  }

  // Convert a CacheControl object to a map
  Map<String, dynamic> toMap() {
    return {
      'max-age': maxAge,
      's-maxage': sMaxAge,
      'no-cache': noCache,
      'no-store': noStore,
      'must-revalidate': mustRevalidate,
      'proxy-revalidate': proxyRevalidate,
      'no-transform': noTransform,
      'public': public,
      'private': private,
    };
  }
}
