/// Cache control model for the Pluggable system.
/// 
/// This class represents HTTP Cache-Control directives, which control
/// how caching is performed by browsers and intermediate caches.
/// 
/// Example usage:
/// ```dart
/// // Create a cache control object
/// final cacheControl = CacheControl(
///   maxAge: 3600, // Cache for 1 hour
///   mustRevalidate: true,
///   public: true,
/// );
/// 
/// // Parse from a header string
/// final parsed = CacheControl.parse('max-age=3600, must-revalidate, public');
/// 
/// // Convert to a header string
/// final header = cacheControl.toString();
/// ```

/// Class representing HTTP Cache-Control directives
class CacheControl {
  /// Maximum amount of time a resource is considered fresh (in seconds)
  final int? maxAge;

  /// Maximum amount of time a resource is considered fresh in shared caches (in seconds)
  final int? sMaxAge;

  /// Whether the response should not be cached
  final bool noCache;

  /// Whether the response should not be stored
  final bool noStore;

  /// Whether the cache must revalidate the resource before using it
  final bool mustRevalidate;

  /// Whether shared caches must revalidate the resource before using it
  final bool proxyRevalidate;

  /// Whether the response should not be transformed
  final bool noTransform;

  /// Whether the response can be cached by any cache
  final bool public;

  /// Whether the response is intended for a single user
  final bool private;

  /// Creates a new cache control object
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

  /// Converts the CacheControl object to a string representation
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

  /// Parses a Cache-Control header string and returns a CacheControl object
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

  /// Creates a CacheControl object from a map
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

  /// Converts a CacheControl object to a map
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
