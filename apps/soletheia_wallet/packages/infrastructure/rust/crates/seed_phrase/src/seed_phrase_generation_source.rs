use crate::SeedPhraseWordCount;

pub enum SeedPhraseGenerationSource<'a> {
    Random(SeedPhraseWordCount),
    Entropy(&'a [u8]),
}
