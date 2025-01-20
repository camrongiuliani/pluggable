enum ValidationOperation {
  custom,
  contains,
  notContains,
  equals,
  exists,
  notEquals,
  notNull,
  notNullOrEmpty,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
}

typedef CustomValidator = Exception? Function(Map<String, dynamic>);
