import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/__docusaurus/debug',
    component: ComponentCreator('/__docusaurus/debug', 'f0f'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/config',
    component: ComponentCreator('/__docusaurus/debug/config', '51a'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/content',
    component: ComponentCreator('/__docusaurus/debug/content', '97e'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/globalData',
    component: ComponentCreator('/__docusaurus/debug/globalData', '1c7'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/metadata',
    component: ComponentCreator('/__docusaurus/debug/metadata', 'a39'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/registry',
    component: ComponentCreator('/__docusaurus/debug/registry', '60d'),
    exact: true
  },
  {
    path: '/__docusaurus/debug/routes',
    component: ComponentCreator('/__docusaurus/debug/routes', '0d4'),
    exact: true
  },
  {
    path: '/notes',
    component: ComponentCreator('/notes', 'abd'),
    routes: [
      {
        path: '/notes/',
        component: ComponentCreator('/notes/', '4cb'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/computer-science/',
        component: ComponentCreator('/notes/computer-science/', 'f90'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/computer-science/category-theory/',
        component: ComponentCreator('/notes/computer-science/category-theory/', '7e9'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/computer-science/data-structures/',
        component: ComponentCreator('/notes/computer-science/data-structures/', 'a44'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/computer-science/data-structures/linear-list',
        component: ComponentCreator('/notes/computer-science/data-structures/linear-list', '0dc'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/computer-science/programming-language',
        component: ComponentCreator('/notes/computer-science/programming-language', '4c8'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/',
        component: ComponentCreator('/notes/dev-env/', '8e1'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/git',
        component: ComponentCreator('/notes/dev-env/git', 'fe6'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/helix',
        component: ComponentCreator('/notes/dev-env/helix', 'aea'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/macos-recommended-apps',
        component: ComponentCreator('/notes/dev-env/macos-recommended-apps', 'e14'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/tmux',
        component: ComponentCreator('/notes/dev-env/tmux', 'e8a'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/dev-env/use-vim-arrow-in-macos',
        component: ComponentCreator('/notes/dev-env/use-vim-arrow-in-macos', 'b4e'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/diy/',
        component: ComponentCreator('/notes/diy/', '16e'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/diy/crkbd/',
        component: ComponentCreator('/notes/diy/crkbd/', '746'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/diy/crkbd/miryoku',
        component: ComponentCreator('/notes/diy/crkbd/miryoku', '230'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/diy/uibox/',
        component: ComponentCreator('/notes/diy/uibox/', '12b'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/diy/uirouter',
        component: ComponentCreator('/notes/diy/uirouter', '9ef'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/hanassig/',
        component: ComponentCreator('/notes/hanassig/', 'f2e'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/',
        component: ComponentCreator('/notes/programming-languages/', '379'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/',
        component: ComponentCreator('/notes/programming-languages/elixir/', '49f'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/bitstrings',
        component: ComponentCreator('/notes/programming-languages/elixir/bitstrings', 'f41'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/dialyxir',
        component: ComponentCreator('/notes/programming-languages/elixir/dialyxir', 'a41'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/module-directives',
        component: ComponentCreator('/notes/programming-languages/elixir/module-directives', '61a'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/OTP',
        component: ComponentCreator('/notes/programming-languages/elixir/OTP', '6c0'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/elixir/process',
        component: ComponentCreator('/notes/programming-languages/elixir/process', 'a02'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/programming-languages/rust/',
        component: ComponentCreator('/notes/programming-languages/rust/', '882'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/side-projects/',
        component: ComponentCreator('/notes/side-projects/', '9ab'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/side-projects/nth-weekday',
        component: ComponentCreator('/notes/side-projects/nth-weekday', '721'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/side-projects/sangatsu',
        component: ComponentCreator('/notes/side-projects/sangatsu', '9b5'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/web-backend/',
        component: ComponentCreator('/notes/web-backend/', 'a5f'),
        exact: true,
        sidebar: "tutorialSidebar"
      },
      {
        path: '/notes/web-backend/phoenix-framework',
        component: ComponentCreator('/notes/web-backend/phoenix-framework', '0f2'),
        exact: true,
        sidebar: "tutorialSidebar"
      }
    ]
  },
  {
    path: '/',
    component: ComponentCreator('/', 'bae'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
