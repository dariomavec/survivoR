library(dplyr)
library(purrr)
library(stringr)

context("Castaways")

test_that("There are no NAs in castaway_id", {

  expect_equal(all(castaways$castaway_id != "USNA"), TRUE)

})

test_that("There are no NAs in age", {

  expect_equal(all(!is.na(castaways$age)), TRUE)

})

test_that("There are no NAs in age", {

  expect_equal(all(!is.na(castaways$age)), TRUE)

})

test_that("There are no NAs in city", {

  expect_equal(all(!is.na(castaways$city)), TRUE)

})

test_that("There are no NAs in state", {

  expect_equal(all(!is.na(castaways$state)), TRUE)

})


test_that("There are no castaway name inconsistencies across data frames within seasons", {

    castaways <- survivoR::castaways |>
      distinct(season, full_name, castaway, castaway_id)

    vote_history_castaway <- survivoR::vote_history |>
      distinct(season, castaway, castaway_id)

    vote_history_vote <- survivoR::vote_history |>
      distinct(season, castaway = vote, castaway_id = vote_id)

    vote_history_voted_out <- survivoR::vote_history |>
      distinct(season, castaway = voted_out, castaway_id = voted_out_id)

    # challenges <- survivoR::challenges |>
    #   unnest(c(winners)) |>
    #   distinct(season, castaway = winners, castaway_id = winners_id)

    challenge_results <- survivoR::challenge_results |>
      unnest(c(winners)) |>
      distinct(season, castaway = winner, castaway_id = winner_id)

    confessionals <- survivoR::confessionals |>
      distinct(season, castaway, castaway_id)

    jury_votes_castaway <- survivoR::jury_votes |>
      distinct(season, castaway, castaway_id)

    jury_votes_finalist <- survivoR::jury_votes |>
      distinct(season, castaway = finalist, castaway_id = finalist_id)

    tribe_mapping <- survivoR::tribe_mapping |>
      distinct(season, castaway, castaway_id)

    inconsistent_names <- castaways |>
      left_join(vote_history_castaway, by = c("season", "castaway_id"), suffix = c("", "_vote_history")) |>
      left_join(vote_history_vote, by = c("season", "castaway_id"), suffix = c("", "_vote")) |>
      left_join(vote_history_voted_out, by = c("season", "castaway_id"), suffix = c("", "_voted_out")) |>
      # left_join(challenges, by = c("season", "castaway_id"), suffix = c("", "_challenges")) |>
      left_join(challenge_results, by = c("season", "castaway_id"), suffix = c("", "_challenge_results")) |>
      left_join(confessionals, by = c("season", "castaway_id"), suffix = c("", "_confessionals")) |>
      left_join(jury_votes_castaway, by = c("season", "castaway_id"), suffix = c("", "_jury")) |>
      left_join(jury_votes_finalist, by = c("season", "castaway_id"), suffix = c("", "_finalist")) |>
      # left_join(hidden_idols, by = c("season", "castaway_id"), suffix = c("", "_hidden")) |>
      left_join(tribe_mapping, by = c("season", "castaway_id"), suffix = c("", "_mapping")) |>
      mutate_if(is.character, ~ifelse(is.na(.x), castaway, .x)) |>
      filter(
        # season != 42,
        !(castaway == castaway_vote_history &
            castaway == castaway_vote &
            castaway == castaway_voted_out &
            # castaway == castaway_challenges &
            castaway == castaway_challenge_results &
            castaway == castaway_confessionals &
            castaway == castaway_jury &
            castaway == castaway_finalist &
            # castaway == castaway_hidden &
            castaway == castaway_mapping)
      )

    expect_equal(nrow(inconsistent_names), 0)

})

test_that("Only one winner of the final immunity challenge", {

  x <- challenge_results |>
    filter(season != 42) |>
    filter(challenge_type == "Immunity") |>
    group_by(season) |>
    slice_max(day) |>
    unnest(winners) |>
    filter(outcome_status == "Winner") |>
    nrow()

  expect_equal(x, nrow(season_summary)-1)

})


test_that("No NAs in castaway_ids", {

  expect_equal(all(!is.na(castaways$castaway_id)), TRUE)

})

