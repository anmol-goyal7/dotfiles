// node --test no-shorts/tests
const test = require('node:test');
const assert = require('node:assert/strict');
const { isBlocked } = require('../extension/no-shorts.user.js');

const blocked = [
  'https://www.youtube.com/shorts/dQw4w9WgXcQ',
  'https://youtube.com/shorts/dQw4w9WgXcQ?feature=share',
  'https://m.youtube.com/shorts/dQw4w9WgXcQ',
  'https://www.youtube.com/shorts',
  'https://www.youtube.com/shorts/',
  'https://www.youtube.com/@mkbhd/shorts',
  'https://www.youtube.com/channel/UCBJycsmduvYEL83R_U4JriQ/shorts',
  'https://www.youtube.com/c/mkbhd/shorts',
  'https://www.youtube.com/user/marquesbrownlee/shorts',
  'https://www.youtube.com/hashtag/funny/shorts',
  'https://www.instagram.com/reels/',
  'https://www.instagram.com/reels',
  'https://www.instagram.com/reels/C9abc123/',
  'https://www.instagram.com/reel/C9abc123/',
  'https://instagram.com/reel/C9abc123/?igsh=xyz',
  'https://www.instagram.com/natgeo/reels/',
  'https://www.instagram.com/natgeo/reel/C9abc123/',
];

const allowed = [
  'https://www.youtube.com/',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  'https://www.youtube.com/results?search_query=shorts',
  'https://www.youtube.com/@mkbhd',
  'https://www.youtube.com/@mkbhd/videos',
  'https://www.youtube.com/@shortsmaker',
  'https://www.youtube.com/@shortsmaker/videos',
  'https://www.youtube.com/feed/subscriptions',
  'https://www.youtube.com/playlist?list=PL123',
  'https://www.instagram.com/',
  'https://www.instagram.com/p/C9abc123/',
  'https://www.instagram.com/natgeo/',
  'https://www.instagram.com/reelhouse/',
  'https://www.instagram.com/direct/inbox/',
  'https://www.instagram.com/stories/natgeo/123/',
  'https://example.com/shorts/dQw4w9WgXcQ',
  'https://notyoutube.com/shorts/dQw4w9WgXcQ',
  'https://youtube.com.evil.example/shorts/dQw4w9WgXcQ',
  'https://example.com/reels/',
  'not a url',
  '',
];

for (const url of blocked) {
  test(`blocks ${url}`, () => assert.equal(isBlocked(url), true));
}

for (const url of allowed) {
  test(`allows ${url || '(empty)'}`, () => assert.equal(isBlocked(url), false));
}
