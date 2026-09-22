# SaTML 2027 event page

This directory contains the `/satml2027` event page on the `satml27` branch.

The page follows the established AdvML event structure and visual language: the dark fixed header, conference banner, pink accent color, schedule rows, and past-event links. It incorporates HuG ideas where they improve usability: a concise workshop note followed by one expandable CFP, alternating speaker profiles, expandable program details, compact organizer portraits, stronger mobile behavior, and accessible navigation.

The public-facing content is populated from the supplied SaTML workshop proposal. Internal planning details are intentionally omitted. SaTML 2027 is in Reykjavík, Iceland; the exact venue is still forthcoming. The submission platform and keynote speakers and talk details also remain provisional.

## Where to edit

Most event content is in `index.html`. Search for `forthcoming` to find the details still awaiting confirmation.

| Content | Location in `index.html` |
| --- | --- |
| Workshop title, date, and venue | `#intro` |
| Expandable call and important dates | `#CallForPapers` |
| Workshop note | `.workshop-note` |
| Keynote announcement | `#speakers` |
| Program | `#schedule` |
| Organizers | `#organizers` |
| Contact email | `#footer` |

When keynote speakers are announced, add their portraits under `assets/images/speakers/`. Organizer portraits are in `assets/images/organizers/`. Use descriptive alternative text when adding an image, for example:

```html
<img src="assets/images/speaker-name.jpg" alt="Speaker Name">
```

Page-specific styling is in `css/style.css`; the small dependency-free interaction layer is in `js/main.js`. The page intentionally does not load the older jQuery, animation, carousel, or duplicated Bootstrap bundles, which removes several common sources of menu and loading glitches.

## Preview

From the repository root, run `make serve`, then open `http://127.0.0.1:8000/satml2027`. Override the defaults with values such as `make serve PORT=8080`. A server is preferable to opening the HTML directly because it matches GitHub Pages path behavior.

## Publishing

Once this branch is merged into the branch served by GitHub Pages, the event will be available at `/satml2027`. Existing root and archived event pages are unchanged.
