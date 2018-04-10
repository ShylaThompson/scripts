1. Open a powershell prompt at root of your local repo.
2. Run the following commands to output a 30 day diff of a branch called "live":

```
$LiveDiff = git diff --name-only $(git log --until="30 days ago" -n1 --format=%H live) live
$LiveDiff | Out-File "Live30DayDiff.txt" 
```

