class Sphere extends SceneObject {
  Vector3 center;
  float radius;
  float radiusSquared;

  Sphere(Vector3 center, float radius, float albedo) {
    this.center = center;
    this.radius = radius;
    this.radiusSquared = radius * radius;
    this.albedo = albedo;
  }

  Sphere(JSONObject j) {
    this.center = new Vector3(j.getJSONObject("center"));
    this.radius = j.getFloat("radius");
    this.radiusSquared = this.radius * this.radius;
    this.albedo = j.getFloat("albedo");
  }

  JSONObject toJSONObject() {
    JSONObject j = new JSONObject();
    j.setJSONObject("center", this.center.toJSONObject());
    j.setFloat("radius", this.radius);
    j.setFloat("albedo", this.albedo);
  }

  float rayIntersect(Ray ray) {
    Vector3 co = ray.origin.minus(this.center);

    float a = ray.direction.dotSelf();
    float b = 2 * ray.direction.dot(co);
    float c = co.dotSelf() - radiusSquared;

    Vector2 hits = solveQuadratic(a, b, c);
    if (hits == null)
      return 0;

    // hits.x and hits.y aren't really x and y values, they simply represent the first and second root
    if (hits.y < 0) // Both rays are behind the camera
      return 0;
    float t;
    if (hits.x < 0)
      t = hits.y;
    else
      t = hits.x;

    return t;
  }

  Vector3 getNormal(Vector3 point) {
    Vector3 normal = point.minus(this.center);
    normal.normalize();
    return normal;
  }
}