import { defineConfig } from 'vitepress'
import { readdirSync, readFileSync } from 'node:fs'
import { join } from 'node:path'

// Build the sidebar from each page's `sort:` front matter and first heading,
// the same way the old Jekyll theme did, so new pages show up automatically.
function guideSidebar(dir: string) {
  const root = join(__dirname, '..', dir)
  return readdirSync(root)
    .filter((f) => f.endsWith('.md') && f !== 'index.md')
    .map((f) => {
      const src = readFileSync(join(root, f), 'utf8')
      const sort = Number(src.match(/^sort:\s*(\d+)/m)?.[1] ?? 999)
      const text = src.match(/^#{1,6}\s+(.+)$/m)?.[1]?.trim() ?? f.replace(/\.md$/, '')
      return { sort, text, link: `/${dir}/${f.replace(/\.md$/, '')}` }
    })
    .sort((a, b) => a.sort - b.sort || a.text.localeCompare(b.text))
    .map(({ text, link }) => ({ text, link }))
}

export default defineConfig({
  title: 'OptiHack',
  description: 'Hackintosh guide for Dell OptiPlex 7020/9020',
  base: '/OptiHack/',
  lastUpdated: true,
  head: [
    ['link', { rel: 'icon', href: '/OptiHack/favicon.png' }],
    ['link', { rel: 'apple-touch-icon', href: '/OptiHack/apple-touch-icon.jpg' }],
  ],
  themeConfig: {
    nav: [
      { text: 'Guide', link: '/OptiGuide/installation' },
      { text: 'Releases', link: 'https://github.com/zearp/OptiHack/releases' },
    ],
    sidebar: [{ text: 'Hackintosh Guide', items: guideSidebar('OptiGuide') }],
    socialLinks: [{ icon: 'github', link: 'https://github.com/zearp/OptiHack' }],
    search: { provider: 'local' },
    outline: 'deep',
    editLink: {
      pattern: 'https://github.com/zearp/OptiHack/edit/master/docs/:path',
    },
  },
})
