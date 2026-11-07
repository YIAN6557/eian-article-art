> 可选。把做好的图和文章放进 X 文章草稿或微信公众号草稿的方法，需要能操作浏览器的 agent（比如 Claude Code 的内置浏览器）。只存草稿，**永远不替用户点发布**，也不替用户登录。

# 把图放进 X 文章草稿

只放图，**绝不点 Publish**，由用户自己发布。不替用户登录。两个地方同时开编辑页会互相覆盖，先让用户关掉别的窗口。

X 编辑器是 Draft.js，真实 cmd+v 和键盘输入无效，要用 JS。视口要宽（1400×1000），不然没有 Insert。

把图带到 x.com：起一个本地静态服务，在标签页打开 localhost 页面，fetch 图转 base64 写进 `window.name`，再 navigate 到 x.com，`window.name` 还在。做完要清空，服务也要停。

**封面**：DataTransfer 设到第一个 `input[data-testid="fileInput"]`（不带 multiple），派发 change，在 Edit media 对话框点 Apply。

**正文插图**（不要用 Insert → Media，图会落到旧光标处）：
1. 插之前存下每段文字，用来比对。**从后往前插**，这样前面的位置不变。
2. 滚到目标段，用真实 left_click 点这一段最后一行的右边。窗口没焦点时，JS 设的选区不生效。
3. 确认 `getSelection()` 在目标段末尾，再派发合成 paste：`new ClipboardEvent('paste',{bubbles:true,cancelable:true,clipboardData:dt})`，dt 里放 File。
4. 上传要等 20 到 60 秒，别重复发。pane 隐藏时单次 JS 超过 45 秒会超时，要分开调用。
5. 每张都核对：图的前后段落对不对，文字有没有变。不对就点 `aria-label="Remove media"` 删掉再来。

全部插完，打开 `/preview/focus` 预览页等加载完，核对图和文字都在，这才算保存成功。

# 把文章放进微信公众号草稿

只存草稿，**绝不点发表或群发**。用户自己扫码登录。不用预览功能发给别人。

- 编辑页：`/cgi-bin/appmsg?t=media/appmsg_edit_v2&action=edit&isNew=1&type=77&createType=0&token=...`，token 从登录后的网址取。
- 这里有两个 `.ProseMirror`，第一个是标题。正文要用 `.rich_media_content .ProseMirror`，选错会把全文贴进标题。真实点击正文后，确认焦点在正文上再粘贴。
- 标题：选中标题框后用 `document.execCommand('insertText')`。
- 正文：派发带 `text/html` 的合成 paste，内联样式、h2/h3、列表、表格、`pre`、`hr` 都能保留。图先写成 `[[FIG1]]` 占位。
- 图：用 JS 选中占位符文字，派发 clipboardData 带 File 的 paste，会自动上传到微信。之后光标留在多出来的空行里，按真实 Delete 删掉。**Delete 会让下一段丢掉加粗**，要检查并用真实 cmd+b 补回来。
- 封面：比例 2.35:1，2000×851（`cover.html` 把高度改成 851，`#art` 的 top 改成 66，截图时写上尺寸：`shot.sh cover_wechat.html final/cover_wechat.png 2000 851`）。上传后在“编辑封面”把 1:1 的框缩小，只框住左边的画，别带上右边的字。
- 保存后刷新，从服务器读回来核对文字、图、加粗、表格和代码块。

# 把整篇正文放进 X 草稿（文字、代码、表格、分隔线）

- 正文用合成 paste（`text/html`，h1=Heading，h2=Subheading，strong、ul/ol 都保留）；代码、表格、分隔线走 Insert 菜单（Code 对话框填 textarea 点 Insert；Table 选 5×2 后点 Edit block，在 textarea 写 markdown 点 Update）。
- **菜单偶尔没点上也不报错**，下一段 html 会粘进上一段末尾。每插一个都检查最后一个 section 的内容，没成功就关菜单重试。
- 图可以按顺序直接粘 File（光标在文末时会落在当前位置，后面自动留一个空行给下一段）。
- 放完逐块对照：块类型、每段全文、代码全文、表格每一格、加粗数、图前面的段落。
- 重开编辑页（不是 /preview/focus）从服务器读回再对照一次。pane 隐藏时要等约 1 分钟才出正文。
