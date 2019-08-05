library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "tidytracker")

#Set your name
my_desc$set("Authors@R", "person('Emily', 'Riederer', email = 'emilyriederer@gmail.com', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Task tracking the tidy way")
# The description of your package
my_desc$set(Description = "Provides a highly abstracted wrapper for the GitHub API with a focus on project management.
    For example, key functionality includes setting up issues and milestones and reporting the progress
    of those events. It should be useful for those using GitHub in personal, professional, or academic
    settings with an emphasis on usage for data analysis projects.")
# The urls
my_desc$set("URL", "https://github.com/emilyriederer/tidytracker")
my_desc$set("BugReports", "https://github.com/emilyriederer/tidytracker/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "Emily Riederer")
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()

# Get the dependencies
use_package("httr")
use_package("jsonlite")
use_package("curl")
use_package("purrr")

# Clean your description
use_tidy_description()
