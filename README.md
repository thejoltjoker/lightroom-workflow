# Lightroom Workflow

## Introduction

Hi friend! 👋

So you found my Lightroom repository! 📷

It used to be only presets but it's turning into more of a full on workflow for lightroom. It's heavily opinionated but feel free to just look through and get some inspiration to make something great of your own!

The presets are free to use. Some of them are great, others not so great. Some only work for certain type of photos and some work for most.

Whatever you end up using this for I hope it will aid in your workflow! 🎉

### About Me

I'm photographer, filmmaker and 3D artist. I do on-set work as a DIT and Data Wrangler and have worked in VFX pipelines.
So because of this I try optimize my own personal workflow as well.

You can find my photography on [Instagram](http://instagram.com/thejoltjoker) and [Unsplash](https://unsplash.com/@thejoltjoker).

### Say Thanks 🍻

If you want to say thanks and also looking for a way to make money off your photos, you can sign up to Wirestock using my referral link! It's a free service to submit your photos to various stock photo sites without the hassle of entering data multiple times.

[Sign up here! (FREE)](https://wirestock.io?ref=johannes.andersson "Sign up to Wirestock.io")

## Other Tools

### Lightroom Sync

Synchronize catalogs across multiple devices to keep them all up to date.

https://github.com/thejoltjoker/lightroom-sync

## Contents

- [Lightroom Workflow](#lightroom-workflow)
  - [Introduction](#introduction)
    - [About Me](#about-me)
    - [Say Thanks 🍻](#say-thanks-)
  - [Other Tools](#other-tools)
    - [Lightroom Sync](#lightroom-sync)
  - [Contents](#contents)
  - [Settings (Develop Presets)](#settings-develop-presets)
    - [Automatic Presets 🤖](#automatic-presets-)
    - [Basic Presets 🏭](#basic-presets-)
    - [HDR Presets 🌄](#hdr-presets-)
    - [Toning Presets 🗺️](#toning-presets-️)
  - [Lightroom (Other Presets)](#lightroom-other-presets)
    - [Export Presets](#export-presets)
    - [Filename Templates](#filename-templates)
    - [Export Actions](#export-actions)
      - [create_contact_sheet](#create_contact_sheet)
  - [Keywords 📋](#keywords-)
    - [Swedish birds 🦆](#swedish-birds-)
    - [Svenska Tätorter 🏙](#svenska-tätorter-)
  - [File and Folder structure](#file-and-folder-structure)
  - [Photos Rating and Tagging](#photos-rating-and-tagging)
    - [Star Ratings](#star-ratings)
    - [Color Ratings](#color-ratings)
  - [Folders Tagging](#folders-tagging)
    - [Workflow](#workflow)
    - [Color Tags](#color-tags)
  - [Catalogs](#catalogs)
    - [Previews](#previews)
    - [Collections](#collections)
  - [Publishing](#publishing)
    - [Publish service](#publish-service)
    - [Organization](#organization)
  - [Metadata](#metadata)
    - [People](#people)
    - [Keywords](#keywords)

## Settings (Develop Presets)

A little explanation of the different classifications I've come up with, might be handy.

### Automatic Presets 🤖

Presets that I normally use for lazy and initial processing of RAW photos.

### Basic Presets 🏭

These presets are the most basic adjustments like camera profiles and such.
I usually apply one of these directly on import.

### HDR Presets 🌄

Presets related to my HDR photography workflow.

### Toning Presets 🗺️

These are my favorite! They're what makes my photos look a certain way.
They're named based on what was in the photo when I created the preset.
So they remind me of different places as well which is always fun!

## Lightroom (Other Presets)

### Export Presets

I will try and gather some common file export presets I use for various exports.

### Filename Templates

Here I will have my file naming templates.

### Export Actions

#### create_contact_sheet

Creates a contact sheet for all the exported photos and puts in the export folder. Requires [ImageMagick](https://imagemagick.org/script/download.php "Downlaod ImageMagick") to be installed.

## Keywords 📋

Keyword lists for use in Lightroom.

### Swedish birds 🦆

A list of birds that can be seen in Sweden. Names are in swedish but synonyms are added in latin and english.

### Svenska Tätorter 🏙

A list of swedish urban areas and their corresponding counties.

## File and Folder structure

Here's an example of the folder structure I use and will refer to in this document.

```
- media
    - photos
        - 2020
            - 2020-12-24
                - 201224_IMG_NAME.RAW
- lightroom
    - catalogs
        - catalog_name
            - catalog_name.lrcat
- output
    - catalog_name
        - collection_name
            - 201224_234359_title.jpg
```

## Photos Rating and Tagging

### Star Ratings

⭐️ - Pick

⭐️⭐️ - Pick

⭐️⭐️⭐️ - Pick

⭐️⭐️⭐️⭐️ - Pick

⭐️⭐️⭐️⭐️⭐️ - Published.

### Color Ratings

💙 - Pick. Equivalent to one star.

💜 - Stock photos.

💚 - Edited and ready to be/is published.

💛 - Edited but not yet published. Still needs work.

❤️ - Pick for editing but untouched.

## Folders Tagging

### Workflow

1. Add the following metadata to all photos.

   - Title
   - Caption
   - Faces
   - Keywords

2. Go through all photos in folder and add star to the keepers.

3. Tag folder green

### Color Tags

💙 - Metadata added, no star ratings.

💜 - _unassigned_

💚 - Star ratings, metadata such as keywords, caption and description added. Also faces.

💛 - Star ratings added but not metadata.

❤️ - Look through, no sorting done.

## Catalogs

All catalogs will be placed in a flat manner under `catalogs/subFolder`.

Have one active catalog for each year.

Version up when upgrading catalog. Keep all catalog files in a flat structure under the year folder.

`lightroom/catalogs/2020/catalog_file_v002.lrcat`

### Previews

Remove the previews for all the old catalogs. Keep all 1:1 previews and smart previews in Dropbox for Smart Sync feature.

### Collections

Smart collections are marked with a \*

- client
  - _client_name_
- editing
  - edit_todo \*
    - rating: is greater than or equal to 1 star
    - label: is not yellow
    - label: is not green
  - edit_doing \*
    - rating: is greater than or equal to 1 star
    - label: is yellow
  - edit_done \*
    - rating: is greater than or equal to 1 star
    - label: is green
  - edit_untouched \*
    - has adjustments: is false
    - file type: is not video
    - file type: is raw
- metadata
  - meta_todo \*
    - caption: is empty
    - title: is empty
    - keywords: are empty
- stock
  - stock_releases \*
    - collection: contains stock_selection
    - keywords: contains person
  - stock_toExport \*
    - collection: contains stock_selection
    - label: is green
    - collection: doesn't contain stock_exported
  - stock_exported
  - stock_selection
- instagram
  - insta_toEdit \*
    - collection: contains insta_selection
    - label: is not green
  - insta_toExport \*
    - collection: contains insta_selection
    - label: is green
    - collection: doesn't contain insta_exported
  - insta_exported
  - insta_selection
- projects
  - _proj_name_

## Publishing

### Publish service

One main publish service for the catalog in output folder. If main year catalog create in output/photos.

- Export location
  - Export to: specific folder
  - Put in subfolder: If year catalog use year otherwise catalog name
- File naming
  - Rename to: date_time_title
  - Extension: lowercase
- Video
  - Include video files
  - Video format: H.264
  - Quality: Max
- File settings
  - Image format: JPEG
  - Quality: 60
  - Color space: sRGB
- Image sizing
  - Don't resize
  - Or x megapixels, don't enlarge
  - 72 ppi
- Output sharpening
  - Sharpen for: Screen
  - Amount: Standard
- Metadata
  - All except camera and camera raw info
  - Remove person and location info

### Organization

1. Create published smart folder and name it `YYMM_description`
   - Keyword `YYMM_description`
   - Rating at least one star
   - Green color label
   - Title is not empty
2. Create new keyword with same name as collection.
3. Apply keyword to all images from shoot.
4. Use ratings and color labels to decide which ones to publish.

## Metadata

### People

Organize all people keywords into a top keyword `person`, then `man` and `woman`

### Keywords

Special keywords are:

- \_portfolio
- \_collections
  - _collection_name_
