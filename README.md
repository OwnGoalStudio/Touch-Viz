# Touch-Viz

[now-on-havoc]: https://havoc.app/package/touchvis

[<img width="150" src="https://docs.havoc.app/img/badges/get_square.svg" />][now-on-havoc]

The **BEST** tweak that displays visual indicators for touch interactions on the screen.

- Animations
- Color pickers
- Multi-touch support
- No touch delay or blocking.
- Legacy, rootless and roothide jailbreaks
- Displaying interactions always or during screen recording only.

## Compatibility

- iOS 15, or 16
- Dopamine and Dopamine (RootHide)
- NathanLR's jailbreak
- SEROTONIN IS SUPPORTED

## Why Touch-Viz, not TouchVis?

In TouchVis, we used some codes (settings bundle only) from [ShowMyTouches](https://github.com/dayanch96/ShowMyTouches), which is a open-source project from [@dayanch96](https://github.com/dayanch96/ShowMyTouches).

Sadly we didn't notice that there's no license declaration in [ShowMyTouches](https://github.com/dayanch96/ShowMyTouches), so it was our fault to use the codes without permission.

To prove that we are not using any unlicensed codes or derived works now, we've published the new [`TVZRootListController.swift`](./TVZRootListController.swift). And you can simply compare it with the [original one](https://github.com/dayanch96/ShowMyTouches/blob/main/SMTPrefs/DVNRootListController.m) from [ShowMyTouches](https://github.com/dayanch96/ShowMyTouches).

And, you can do simple reverse engineering to `TouchVis.dylib` or `TouchViz.dylib` to prove that the tweak core is totally different from [ShowMyTouches](https://github.com/dayanch96/ShowMyTouches).

### TL;DR

- Now we've re-written the whole _TouchVis_ and now it is called _Touch-Viz_.
- Touch-Viz does not contain any codes or derived works from ShowMyTouches.
- If you already bought _TouchVis_, please request a refund and buy _Touch-Viz_ instead.

Thank you for your support.

## Why Touch-Viz, not ShowMyTouches?

- All things REBORN:
  - New tweak core.
  - Settings re-written in **SwiftUI**.
  - No unlicensed codes or derived works!
- No annoying touch-blocking!
- Better animation & drawing performance!
- Supports multi-touch and iPad!
- Automatically hides in “Reachability” mode!
- **CC Support**!

## Localization

See [i18n](./i18n) for more information.

## Open-Source Credits

TouchVis and Touch-Viz partially uses some codes from open-source projects below:

- **MIT License**, @LeoNatan: [LNTouchVisualizer](https://github.com/LeoNatan/LNTouchVisualizer)
