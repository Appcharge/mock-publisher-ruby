# BUGBOT — mock-publisher-ruby

> Watches for naming bugs, missing error branches, and signature/HMAC security issues in this Ruby publisher service.

## Code Quality
- **Variable name mismatch**: Verify assignments like `@priceInCents = priceInDollar` — copy-paste bugs hide type and intent errors.

## Error Handling
- **Missing else branch**: Every conditional that assigns a variable must handle the failure path — unassigned vars cause silent failures.

## Security
- **Signature serialization**: Ensure HMAC comparison is timing-safe and serialization format is validated end-to-end.

## Checklist
- [ ] All instance variable assignments match their source parameter names
- [ ] Signature validation blocks return explicit error responses (401/403) on failure
- [ ] HMAC comparison uses a constant-time method, not `==`
- [ ] Signature serialization format is tested end-to-end
