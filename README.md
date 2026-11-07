# eian-article-art

**Chalkboard-style cover images and illustrations for articles · a skill for Codex and Claude Code (macOS)**

[简体中文](README.zh-CN.md) · English

Give your AI a whole article. It picks the spots that most need a picture and shows you the list plus one sample. Once you approve, it draws the rest and hands back the article with every image in place.

![Cover and 6 illustrations for a 12,000-character article](docs/showcase.jpg)

> Above: a 12,000-character Chinese article about an AI video workflow, with 1 cover and 6 illustrations.

## The look

- Pure black background. Plump little figures with big round heads and no faces, built from loose white chalk scribbles.
- White handwritten text (Hannotate SC). Only tool icons and measuring marks are in color.
- One idea per image, readable at a glance.
- **The AI never draws the text.** Text is added in HTML, so there are no garbled or misspelled letters in Chinese or English.

| A second article: 5-part structure, 7 steps | English version |
|:---:|:---:|
| ![](docs/showcase_article2.jpg) | ![](docs/showcase_en.jpg) |

## What it does

1. **Reads the whole article and picks spots**: about one image per 2,000 Chinese characters (or 1,000 English words). It only picks places that are hard to picture from text alone: who does what, comparisons, right vs wrong, proportions, new terms. No images for code, tables or anecdotes.
2. **Stops once for you**: a list (where each image goes, what it shows, what text it carries) plus one sample image. Nothing else is drawn until you approve.
3. **Draws**: Codex uses its own image tool, with two reference images every time (one for the figures, one for the line texture), so the style stays consistent.
4. **Adds text and renders**: text goes on in HTML, then Chrome renders a PNG. Covers are 2000×800, illustrations 1672×941.
5. **Checks** every image: text not covering the drawing, nothing touching the edges, style matching the samples.
6. **Delivers** all PNGs, the list, and `<article>_配图版.md`: your article unchanged, with the images inserted. If your article already has images or placeholders, it asks before replacing them.

## Install

You need:
- **macOS**: the font Hannotate SC ships with macOS. The first time, download it once in Font Book.
- **Google Chrome** (Chromium or Edge also work) for rendering.
- **Codex** for drawing, signed in with your ChatGPT account. Each image uses your plan's image generation allowance. If you don't have Codex yet:

  ```bash
  npm install -g @openai/codex
  codex login
  ```

  (Or use the ChatGPT desktop app, which includes Codex. See [github.com/openai/codex](https://github.com/openai/codex).)

**Codex** (recommended, since Codex draws by itself):

```bash
git clone https://github.com/YIAN6557/eian-article-art.git ~/.agents/skills/eian-article-art
```

**Claude Code** (it calls your local Codex to draw):

```bash
git clone https://github.com/YIAN6557/eian-article-art.git ~/.claude/skills/eian-article-art
```

Using both? Install into `~/.agents/skills/` and link it:

```bash
mkdir -p ~/.claude/skills
ln -s ~/.agents/skills/eian-article-art ~/.claude/skills/eian-article-art
```

## How to use it

Just ask, for example:

- "Illustrate this article: article.md"
- "Make a cover image for this article"
- "Draw one image that explains this: …"

**One step needs your OK in Codex**: rendering uses Chrome, which can't start inside the Codex sandbox. Codex will ask you to approve running the render command outside the sandbox, or give you the command to run yourself.

The rules the AI follows (in `SKILL.md`) are written in Chinese. Agents read them fine, and the skill works for English articles too.

## Files

```
SKILL.md                      instructions for the AI: style rules, steps, checklist
references/pick_spots.md      how to pick image spots in a whole article
references/layout.md          text layout rules and HTML fixes
references/pitfalls.md        known drawing problems and how to avoid them
references/publish_drafts.md  (optional) putting the result into X Articles or WeChat drafts
templates/                    HTML templates and prompt templates
scripts/codex_image2.sh       lets non-Codex agents draw with your local Codex
scripts/shot.sh               renders an HTML file to PNG
assets/refs/                  the figure reference image
assets/logos/                 Claude, Codex and Seedance icons
examples/                     approved examples: prompts, raw images, HTML, final images
```

## License

[MIT](LICENSE). The Claude, Codex and Seedance icons in `assets/logos/` belong to their companies and are used only to name those tools in images.

By Eian ([@EianLu](https://x.com/EianLu))
