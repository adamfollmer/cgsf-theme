import { apiInitializer } from "discourse/lib/api";

// The like is a "support" mark here: check-in-circle, not a heart.
export default apiInitializer((api) => {
  api.replaceIcon("d-liked", "circle-check");
  api.replaceIcon("d-unliked", "far-circle-check");
});
