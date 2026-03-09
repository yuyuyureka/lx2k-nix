{ lib, fetchFromGitHub }:

fetchFromGitHub {
  owner = "NXP";
  repo = "qoriq-mc-binary";
  rev = "mc_release_10.40.0";
  hash = "sha256-td41almGBhlK74PsEPxCdhl4BqmqOpatgNHBQhnU1kI=";
}
