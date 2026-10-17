// Baut das COSMIC-Theme aus dem gespeicherten ThemeBuilder neu (wie cosmic-settings).
// Rebuilds the COSMIC theme from the saved ThemeBuilder, like cosmic-settings does.
//   cosmic-theme-rebuild                     → Light + Dark neu bauen / rebuild both
//   cosmic-theme-rebuild --export dark FILE  → Builder als .ron exportieren (Import in Einstellungen / cosmic-themes.org)
use cosmic_config::CosmicConfigEntry;
use cosmic_theme::{Theme, ThemeBuilder};

fn load(dark: bool) -> ThemeBuilder {
    let cfg = if dark { ThemeBuilder::dark_config() } else { ThemeBuilder::light_config() }.unwrap();
    match ThemeBuilder::get_entry(&cfg) {
        Ok(b) => b,
        Err((errs, b)) => { eprintln!("Builder-Warnungen: {:?}", errs); b }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() == 4 && args[1] == "--export" {
        let builder = load(args[2] == "dark");
        let text = ron::ser::to_string_pretty(&builder, ron::ser::PrettyConfig::default()).expect("RON");
        std::fs::write(&args[3], text).expect("Datei schreiben");
        println!("exportiert: {}", args[3]);
        return;
    }
    for dark in [false, true] {
        let tcfg = if dark { Theme::dark_config() } else { Theme::light_config() }.unwrap();
        load(dark).build().write_entry(&tcfg).expect("Theme schreiben");
        println!("{} neu gebaut", if dark { "Dark" } else { "Light" });
    }
}
