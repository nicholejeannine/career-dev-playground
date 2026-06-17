# cat_food_bias.py

import statistics

# 4-point Likert scale indicating level of food prefernce (3 most preferred, 0 least preferred).
# Measurements are imprecise because they are based on quick human observations for entertainmet only.
# 0 (least preferred): left half of food served or more (>= 50%)
# 1 - left more than a couple of bites, but ate at least half of his plate
# 2 - more than crumbs, but only one or two small or big bites remaining
# 3 (most preferred) - ate the entire plate, left only crumbs or "trivial leftovers" (not quite a whole bite)


data = [
    {"date": "5/22/26", "box": 2, "meal": "dinner", "flavor": "turkey", "score": 3, "notes": "trivial leftovers"},
    {"date": "5/23/26", "box": 2, "meal": "breakfast", "flavor": "beef", "score": 2, "notes": "half bite left"},
    {"date": "5/23/26", "box": 2, "meal": "dinner", "flavor": "fish", "score": 1, "notes": "2 bites left"},
    {"date": "5/24/26", "box": 2, "meal": "dinner", "flavor": "beef", "score": 3, "notes": "clean plate"},
    {"date": "5/25/26", "box": 2, "meal": "dinner", "flavor": "turkey", "score": 3, "notes": "1/8 plate leftover"},
    {"date": "5/30/26", "box": 2, "meal": "dinner", "flavor": "fish", "score": 3, "notes": "clean plate"},
]

# print(data[1])

# flavors = ["beef", "chicken", "fish", "turkey"]
# for flavor in flavors:
#   scores = [d["score"] for d in data if d["flavor"] == flavor]
#   if scores:
#     median = statistics.median(scores)
#     print(f"{flavor}: median score {median:.2f} (n={len(scores)})")
#   else:
#     print(f"{flavor}: no data")

def median_scores_by(data, field):
  values = set(d[field] for d in data)
  for value in values:
    scores = [d["score"] for d in data if d[field] == value]
    if scores:
      med = statistics.median(scores)
      print(f"{value}: median score {med} (n={len(scores)})")
    else:
      print(f"{value}: no data")

print("--- By flavor ---")
median_scores_by(data, "flavor")
print("--- By Meal ---")
median_scores_by(data, "meal")