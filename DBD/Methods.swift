import UIKit

enum ValidationError: Error {
    case invalidLength
    case invalidString
}

// MARK: Methods

/* steamIDかCustomID の入力に適するかを検証 */
func validateIDs(_ input: String) throws {
    guard !((input).isEmpty) else {
        throw ValidationError.invalidLength
    }
    guard (input).count <= 40 else {
        throw ValidationError.invalidLength
    }
    guard isVanityURL(input) else {
        throw ValidationError.invalidString
    }
}

func isVanityURL(_ key: String) -> Bool {
    // 半角英数字と-_　以外の値が一つでもあればvanityURLではない
    let regex = try? NSRegularExpression(pattern: "[^a-zA-Z0-9_-]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}

func isNumber(_ key: String) -> Bool {
    // 数字以外の値が一つでもあれば数字ではない
    let regex = try? NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}

func getLocalizedStatName(stat: Stats, lang language: String) -> String {
    if language == "JP" {
        return getJPStatsName(stat: stat)
    }
    return ""
}

func getJPStatsName(stat: Stats) -> String {
    
        switch stat.name {
        case     "DBD_KillerSkulls"    :    return    "キラー ランク"
        case     "DBD_CamperSkulls"    :    return    "サバイバー ランク"
        //case     "DBD_ProfileStatsVersion"    :    return
        case     "DBD_KilledCampers"    :    return    "殺害数"
        case     "DBD_SacrificedCampers"    :    return    "処刑数"
        case     "DBD_TrapPickup"    :    return    "トラッパー トラバサミから担いだ数"
        case     "DBD_ChainsawHit"    :    return    "ヒルビリー チェーンソーヒット数"
        case     "DBD_GeneratorPct_float"    :    return    "修理した発電機の数"
        case     "DBD_HealPct_float"    :    return    "治療したサバイバーの数"
        case     "DBD_EscapeKO"    :    return    "這いずり状態で脱出した回数"
        case     "DBD_Escape"    :    return    "脱出成功数"
        case     "DBD_SkillCheckSuccess"    :    return    "スキルチェック成功数"
//        case     "DBD_SacrificedCampers_iam"    :    return
//        case     "DBD_KilledCampers_iam"    :    return
//        case     "DBD_HookedAndEscape"    :    return
        case     "DBD_UnhookOrHeal"    :    return    "フック救助/這いずり状態を起こした数"
        case     "DBD_UnhookOrHeal_PostExit"    :    return    "ゲート解放後に フック救助/這いずり状態を起こした数"
        //case     "DBD_BloodwebMaxLevel"    :    return
        case     "DBD_BloodwebPoints"    :    return    "ブラッドポイント"
        case     "DBD_CamperMaxScoreByCategory"    :    return    "ハイスコアゲーム数"
        case     "DBD_SlasherMaxScoreByCategory"    :    return    "ハイスコアゲーム数"
        //case     "DBD_BloodwebMaxPrestigeLevel"    :    return
        case     "DBD_UncloakAttack"    :    return    "レイス 透明化解除攻撃数"
        //case     "DBD_BloodwebPrestige3MaxLevel"    :    return
        case     "DBD_EscapeThroughHatch"    :    return    "ハッチ脱出数"
//        case     "DBD_PerksCount_Idx0"    :    return
//        case     "DBD_PerksCount_Idx1"    :    return
//        case     "DBD_PerksCount_Idx2"    :    return
//        case     "DBD_PerksCount_Idx3"    :    return
//        case     "DBD_PerksCount_Idx268435456"    :    return
//        case     "DBD_PerksCount_Idx268435457"    :    return
//        case     "DBD_PerksCount_Idx268435458"    :    return
//        case     "DBD_BloodwebPerkMaxLevel"    :    return
//        case     "DBD_MaxBloodwebPointsOneCategory"    :    return
        case     "DBD_BurnOffering_UltraRare"    :    return    "ウルトラレアオファリングを使用した数"
        case     "DBD_CamperFullLoadout"    :    return    "フルロードアウトでプレイした数"
        case     "DBD_SlasherFullLoadout"    :    return    "フルロードアウトでプレイした数"
        case     "DBD_CamperNewItem"    :    return    "アイテムを持ち込んだ儀式で脱出した数"
        //case     "DBD_CamperKeepUltraRare"    :    return
        case     "DBD_AllEscapeThroughHatch"    :    return    "サバイバー全員でハッチから脱出した儀式数"
        case     "DBD_CamperEscapeWithItemFrom"    :    return    "誰かが持ち込んだアイテムを持って脱出した数"
//        case     "DBD_UnlockRanking"    :    return
//        case     "DBD_SaveCounter"    :    return
//        case     "DBD_FinishWithPerks_Idx4"    :    return
//        case     "DBD_EscapeNoBlood_MapAsy_Asylum"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapAsy_Asylum"    :    return
        case     "DBD_SlasherChainAttack"    :    return    "ナース  ブリンク攻撃数"
        case     "DBD_SlasherChainInterruptAfter3"    :    return    "ナース 3ブリンク目でキャッチした数"
//        case     "DBD_FinishWithPerks_Idx268435459"    :    return
//        case     "DBD_FinishWithPerks_Idx268435461"    :    return
//        case     "DBD_FinishWithPerks_Idx5"    :    return
        case     "DBD_SlasherTierIncrement"    :    return    "シェイプ ティアアップ数"
        case     "DBD_SlasherPowerKillAllCampers"    :    return    "シェイプ サバイバー全員を墓石アドオンで殺害した儀式数"
        //case     "DBD_FixSecondFloorGenerator_MapSub_Street"    :    return
        case     "DBD_EscapeNoBlood_Obsession"    :    return    "一切攻撃を受けずにオブセッション状態で脱出した数"
        //case     "DBD_FinishWithPerks_Idx268435460"    :    return
        case     "DBD_DLC3_Slasher_Stat1"    :    return    "ハグ 魔法陣を発動させた数"
        case     "DBD_DLC3_Slasher_Stat2"    :    return    "ハグ 全サバイバーにテレポート攻撃を当てた儀式数"
//        case     "DBD_FinishWithPerks_Idx6"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapSwp_PaleRose"    :    return
        case     "DBD_DLC3_Camper_Stat1"    :    return    "トーテム浄化数"
        //case     "DBD_FinishWithPerks_Idx7"    :    return
        case     "DBD_HitNearHook"    :    return    "フック近くで仲間の身代わりに攻撃を受けた数"
        case     "DBD_LastSurvivorGeneratorEscape"    :    return    "最後の生存者として最後の発電機を起動しゲートから脱出した儀式数"
        case     "DBD_Camper8_Stat1"    :    return    "ダメージを受けた発電機を修理した数"
        case     "DBD_Camper8_Stat2"    :    return    "チェイス時にパレット/窓枠を跳び越えた回数"
        //case     "DBD_FinishWithPerks_Idx8"    :    return
        case     "DBD_DLC4_Slasher_Stat1"    :    return    "ドクター ショック数"
        case     "DBD_DLC4_Slasher_Stat2"    :    return    "ドクター 全サバイバーを狂気段階3にした儀式数"
        //case     "DBD_FinishWithPerks_Idx268435462"    :    return
        case     "DBD_Camper9_Stat2"    :    return    "儀式の時間の半分強を負傷状態で過ごし脱出した数"
        //case     "DBD_FinishWithPerks_Idx9"    :    return
        case     "DBD_DLC5_Slasher_Stat1"    :    return    "ハントレス ハチェットを投げた数"
        case     "DBD_DLC5_Slasher_Stat2"    :    return    "ハントレス 24m以上離れたところからハチェットでダウンさせた数"
//        case     "DBD_FinishWithPerks_Idx268435463"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapBrl_MaHouse"    :    return
//        case     "DBD_FinishWithPerks_Idx268435464"    :    return
        case     "DBD_DLC6_Slasher_Stat2"    :    return    "地下室のフックに吊るした人数"
        case     "DBD_DLC6_Slasher_Stat1"    :    return    "カニバル チェーンソーヒット数"
        case     "DBD_DLC7_Slasher_Stat1"    :    return    "ナイトメア ドリームワールドに引き込んだ数"
        case     "DBD_DLC7_Slasher_Stat2"    :    return    "オブセッションを生贄にした数"
        case     "DBD_DLC7_Camper_Stat1"    :    return    "チェストを開けた数"
        case     "DBD_DLC7_Camper_Stat2"    :    return    "ゲートを開けた数"
//        case     "DBD_FinishWithPerks_Idx11"    :    return
//        case     "DBD_FinishWithPerks_Idx268435465"    :    return
        case     "DBD_DLC8_Slasher_Stat1"    :    return    "ピッグ 逆トラバサミを取り付けた数"
        case     "DBD_DLC8_Slasher_Stat2"    :    return    "通電後に処刑/殺害した人数"
        case     "DBD_DLC8_Camper_Stat1"    :    return    "瀕死状態を経験して脱出した数"
        //case     "DBD_Event1_Stat1"    :    return
        case     "DBD_Event1_Stat2"    :    return    "地下のチェストを開けた数"
//        case     "DBD_Event1_Stat3"    :    return
//        case     "DBD_FinishWithPerks_Idx12"    :    return
//        case     "DBD_FinishWithPerks_Idx268435466"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapFin_Hideout"    :    return
//        case     "DBD_DLC9_Slasher_Stat1"    :    return
        case     "DBD_DLC9_Slasher_Stat2"    :    return    "クラウン トニックの影響下でダウンさせた数"
        case     "DBD_DLC9_Camper_Stat1"    :    return    "チェイス時にパレット/窓枠を跳び越えて攻撃の回避に成功した回数"
//        case     "DBD_FixSecondFloorGenerator_MapAsy_Chapel"    :    return
//        case     "DBD_FinishWithPerks_Idx10"    :    return
//        case     "DBD_FinishWithPerks_Idx268435467"    :    return
//        case     "DBD_FinishWithPerks_Idx0"    :    return
//        case     "DBD_FinishWithPerks_Idx1"    :    return
//        case     "DBD_FinishWithPerks_Idx2"    :    return
//        case     "DBD_FinishWithPerks_Idx3"    :    return
//        case     "DBD_FinishWithPerks_Idx268435456"    :    return
//        case     "DBD_FinishWithPerks_Idx268435457"    :    return
//        case     "DBD_FinishWithPerks_Idx268435458"    :    return
        case     "DBD_Chapter9_Slasher_Stat1"    :    return    "チェイス時にパレットを倒したサバイバーに攻撃した回数"
        case     "DBD_Chapter9_Slasher_Stat2"    :    return    "スピリット 山岡の祟りでダウンさせた数"
        case     "DBD_Chapter9_Camper_Stat1"    :    return    "自力でフックから脱出した数"
//        case     "DBD_FixSecondFloorGenerator_MapHti_Manor"    :    return
//        case     "DBD_FinishWithPerks_Idx13"    :    return
//        case     "DBD_FinishWithPerks_Idx268435468"    :    return
        case     "DBD_Chapter10_Slasher_Stat1"    :    return    "サバイバーを担いで攻撃した数"
        case     "DBD_Chapter10_Slasher_Stat2"    :    return    "深手状態のサバイバーをダウンさせた数"
        //case     "DBD_FinishWithPerks_Idx268435469"    :    return
        case     "DBD_Chapter10_Camper_Stat1"    :    return    "フックを破壊した数"
//        case     "DBD_FixSecondFloorGenerator_MapKny_Cottage"    :    return
//        case     "DBD_FinishWithPerks_Idx14"    :    return
        case     "DBD_Chapter11_Slasher_Stat1"    :    return    "通電前に全滅させた儀式数"
        case     "DBD_Chapter11_Slasher_Stat2"    :    return    "プレイグ 最大レベルの感染状態でダウンさせた数"
        //case     "DBD_FinishWithPerks_Idx268435470"    :    return
        case     "DBD_Chapter11_Camper_Stat1_float"    :    return    "自分が負傷した状態で治療した数"
//        case     "DBD_FixSecondFloorGenerator_MapBrl_Temple"    :    return
//        case     "DBD_FinishWithPerks_Idx15"    :    return
        case     "DBD_Chapter12_Slasher_Stat1"    :    return    "発電機キャッチ数"
        case     "DBD_Chapter12_Slasher_Stat2"    :    return    "ゴーストフェイス マークをつけてダウンさせた数"
        //case     "DBD_FinishWithPerks_Idx268435471"    :    return
        case     "DBD_Chapter12_Camper_Stat1"    :    return    "担がれた状態から もがき抜けた数"
        case     "DBD_Chapter12_Camper_Stat2"    :    return    "這いずり状態からハッチ脱出した数"
        //case     "DBD_FinishWithPerks_Idx16"    :    return
        case     "DBD_Chapter13_Slasher_Stat1"    :    return    "ハッチを閉じた数"
        case     "DBD_Chapter13_Slasher_Stat2"    :    return    "デモゴルゴン シュレッド攻撃でダウンさせた数"
//        case     "DBD_FinishWithPerks_Idx268435472"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapQat_Lab"    :    return
//        case     "DBD_FinishWithPerks_Idx17"    :    return
//        case     "DBD_FinishWithPerks_Idx18"    :    return
//        case     "DBD_Chapter14_Slasher_Stat1"    :    return
        case     "DBD_Chapter14_Slasher_Stat2"    :    return    "鬼 血の怒りでダウンさせた数"
//        case     "DBD_FinishWithPerks_Idx268435473"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapHti_Shrine"    :    return
        case     "DBD_Chapter14_Camper_Stat1"    :    return    "他3人の生存者が負傷している間に、フックに吊るした数"
        //case     "DBD_FinishWithPerks_Idx19"    :    return
        case     "DBD_Chapter15_Slasher_Stat1"    :    return    "デススリンガー 銛が刺さった状態からダウンさせた数"
        case     "DBD_Chapter15_Slasher_Stat2"    :    return    "トーテム浄化中に妨害した数"
//        case     "DBD_FinishWithPerks_Idx268435474"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapUkr_Saloon"    :    return
        case     "DBD_Chapter15_Camper_Stat1"    :    return    "這いずり状態から起こした数"
        //case     "DBD_FinishWithPerks_Idx20"    :    return
        case     "DBD_Chapter16_Slasher_Stat1"    :    return    "エクセキューショナー 贖罪の檻に入れた数"
        case     "DBD_Chapter16_Slasher_Stat2"    :    return    "忘却状態のサバイバーをダウンした数"
//        case     "DBD_FinishWithPerks_Idx268435475"    :    return
//        case     "DBD_FixSecondFloorGenerator_MapWal_Level_01"    :    return
        case     "DBD_Chapter16_Camper_Stat1_float"    :    return    "オブセッションのサバイバーを治療した数"
        //case     "DBD_FinishWithPerks_Idx21"    :    return
        case     "DBD_Chapter17_Slasher_Stat1"    :    return    "ブライト 死の突進で攻撃した数"
        case     "DBD_Chapter17_Slasher_Stat2"    :    return    "無防備状態のサバイバーをダウンさせた数"
        //case     "DBD_FinishWithPerks_Idx268435476"    :    return
        case     "DBD_Chapter17_Camper_Stat1"    :    return    "使い果たしたアイテム数"
        case     "DBD_Chapter17_Camper_Stat2_float"    :    return    "3人以上のサバイバーが負傷、瀕死、またはフックに吊るされている間に、他の生存者を治療した数"
        //case     "DBD_FinishWithPerks_Idx22"    :    return
        case     "DBD_Chapter18_Slasher_Stat1"    :    return    "ツインズ ヴィクトルがしがみついた状態でダウンさせた数"
        case     "DBD_Chapter18_Slasher_Stat2"    :    return    "コラスプ中にフックに吊るした数"
        case     "DBD_Chapter18_Camper_Stat1"    :    return    "生存者を担いだキラーをパレットで怯ませた数"
        case     "DBD_Chapter18_Camper_Stat2_float"    :    return    "ノーパークで1台以上修理し脱出した儀式数"
//        case     "DBD_FinishWithPerks_Idx23"    :    return
//        case     "DBD_FinishWithPerks_Idx268435477"    :    return
        
        default:
            return ""
        }
}

func getStatCategory(stat: Stats) -> String {
    
    switch stat.name {
    case     "DBD_KillerSkulls"    :    return    "Killer"
    case     "DBD_CamperSkulls"    :    return    "Survivor"
    //case     "DBD_ProfileStatsVersion"    :    return
    case     "DBD_KilledCampers"    :    return    "Killer"
    case     "DBD_SacrificedCampers"    :    return    "Killer"
    case     "DBD_TrapPickup"    :    return    "Killer"
    case     "DBD_ChainsawHit"    :    return    "Killer"
    case     "DBD_GeneratorPct_float"    :    return    "Survivor"
    case     "DBD_HealPct_float"    :    return    "Survivor"
    case     "DBD_EscapeKO"    :    return    "Survivor"
    case     "DBD_Escape"    :    return    "Survivor"
    case     "DBD_SkillCheckSuccess"    :    return    "Survivor"
    //case     "DBD_SacrificedCampers_iam"    :    return
    //case     "DBD_KilledCampers_iam"    :    return
    //case     "DBD_HookedAndEscape"    :    return
    case     "DBD_UnhookOrHeal"    :    return    "Survivor"
    case     "DBD_UnhookOrHeal_PostExit"    :    return    "Survivor"
    //case     "DBD_BloodwebMaxLevel"    :    return
    case     "DBD_BloodwebPoints"    :    return    "All"
    case     "DBD_CamperMaxScoreByCategory"    :    return    "Survivor"
    case     "DBD_SlasherMaxScoreByCategory"    :    return    "Killer"
    //case     "DBD_BloodwebMaxPrestigeLevel"    :    return
    case     "DBD_UncloakAttack"    :    return    "Killer"
    //case     "DBD_BloodwebPrestige3MaxLevel"    :    return
    case     "DBD_EscapeThroughHatch"    :    return    "Survivor"
//    case     "DBD_PerksCount_Idx0"    :    return
//    case     "DBD_PerksCount_Idx1"    :    return
//    case     "DBD_PerksCount_Idx2"    :    return
//    case     "DBD_PerksCount_Idx3"    :    return
//    case     "DBD_PerksCount_Idx268435456"    :    return
//    case     "DBD_PerksCount_Idx268435457"    :    return
//    case     "DBD_PerksCount_Idx268435458"    :    return
//    case     "DBD_BloodwebPerkMaxLevel"    :    return
//    case     "DBD_MaxBloodwebPointsOneCategory"    :    return
    case     "DBD_BurnOffering_UltraRare"    :    return    "All"
    case     "DBD_CamperFullLoadout"    :    return    "Survivor"
    case     "DBD_SlasherFullLoadout"    :    return    "Killer"
    case     "DBD_CamperNewItem"    :    return    "Survivor"
    //case     "DBD_CamperKeepUltraRare"    :    return
    case     "DBD_AllEscapeThroughHatch"    :    return    "Survivor"
    case     "DBD_CamperEscapeWithItemFrom"    :    return    "Survivor"
//    case     "DBD_UnlockRanking"    :    return
//    case     "DBD_SaveCounter"    :    return
//    case     "DBD_FinishWithPerks_Idx4"    :    return
//    case     "DBD_EscapeNoBlood_MapAsy_Asylum"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapAsy_Asylum"    :    return
    case     "DBD_SlasherChainAttack"    :    return    "Killer"
    case     "DBD_SlasherChainInterruptAfter3"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435459"    :    return
//    case     "DBD_FinishWithPerks_Idx268435461"    :    return
//    case     "DBD_FinishWithPerks_Idx5"    :    return
    case     "DBD_SlasherTierIncrement"    :    return    "Killer"
    case     "DBD_SlasherPowerKillAllCampers"    :    return    "Killer"
    //case     "DBD_FixSecondFloorGenerator_MapSub_Street"    :    return
    case     "DBD_EscapeNoBlood_Obsession"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx268435460"    :    return
    case     "DBD_DLC3_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC3_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx6"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapSwp_PaleRose"    :    return
    case     "DBD_DLC3_Camper_Stat1"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx7"    :    return
    case     "DBD_HitNearHook"    :    return    "Survivor"
    case     "DBD_LastSurvivorGeneratorEscape"    :    return    "Survivor"
    case     "DBD_Camper8_Stat1"    :    return    "Survivor"
    case     "DBD_Camper8_Stat2"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx8"    :    return
    case     "DBD_DLC4_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC4_Slasher_Stat2"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx268435462"    :    return
    case     "DBD_Camper9_Stat2"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx9"    :    return
    case     "DBD_DLC5_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC5_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435463"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapBrl_MaHouse"    :    return
//    case     "DBD_FinishWithPerks_Idx268435464"    :    return
    case     "DBD_DLC6_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_DLC6_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC7_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC7_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_DLC7_Camper_Stat1"    :    return    "Survivor"
    case     "DBD_DLC7_Camper_Stat2"    :    return    "Survivor"
//    case     "DBD_FinishWithPerks_Idx11"    :    return
//    case     "DBD_FinishWithPerks_Idx268435465"    :    return
    case     "DBD_DLC8_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_DLC8_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_DLC8_Camper_Stat1"    :    return    "Survivor"
    //case     "DBD_Event1_Stat1"    :    return
    case     "DBD_Event1_Stat2"    :    return    "Survivor"
//    case     "DBD_Event1_Stat3"    :    return
//    case     "DBD_FinishWithPerks_Idx12"    :    return
//    case     "DBD_FinishWithPerks_Idx268435466"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapFin_Hideout"    :    return
//    case     "DBD_DLC9_Slasher_Stat1"    :    return
    case     "DBD_DLC9_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_DLC9_Camper_Stat1"    :    return    "Survivor"
//    case     "DBD_FixSecondFloorGenerator_MapAsy_Chapel"    :    return
//    case     "DBD_FinishWithPerks_Idx10"    :    return
//    case     "DBD_FinishWithPerks_Idx268435467"    :    return
//    case     "DBD_FinishWithPerks_Idx0"    :    return
//    case     "DBD_FinishWithPerks_Idx1"    :    return
//    case     "DBD_FinishWithPerks_Idx2"    :    return
//    case     "DBD_FinishWithPerks_Idx3"    :    return
//    case     "DBD_FinishWithPerks_Idx268435456"    :    return
//    case     "DBD_FinishWithPerks_Idx268435457"    :    return
//    case     "DBD_FinishWithPerks_Idx268435458"    :    return
    case     "DBD_Chapter9_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter9_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_Chapter9_Camper_Stat1"    :    return    "Survivor"
//    case     "DBD_FixSecondFloorGenerator_MapHti_Manor"    :    return
//    case     "DBD_FinishWithPerks_Idx13"    :    return
//    case     "DBD_FinishWithPerks_Idx268435468"    :    return
    case     "DBD_Chapter10_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter10_Slasher_Stat2"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx268435469"    :    return
    case     "DBD_Chapter10_Camper_Stat1"    :    return    "Survivor"
//    case     "DBD_FixSecondFloorGenerator_MapKny_Cottage"    :    return
//    case     "DBD_FinishWithPerks_Idx14"    :    return
    case     "DBD_Chapter11_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter11_Slasher_Stat2"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx268435470"    :    return
    case     "DBD_Chapter11_Camper_Stat1_float"    :    return    "Survivor"
//    case     "DBD_FixSecondFloorGenerator_MapBrl_Temple"    :    return
//    case     "DBD_FinishWithPerks_Idx15"    :    return
    case     "DBD_Chapter12_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter12_Slasher_Stat2"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx268435471"    :    return
    case     "DBD_Chapter12_Camper_Stat1"    :    return    "Survivor"
    case     "DBD_Chapter12_Camper_Stat2"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx16"    :    return
    case     "DBD_Chapter13_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter13_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435472"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapQat_Lab"    :    return
//    case     "DBD_FinishWithPerks_Idx17"    :    return
//    case     "DBD_FinishWithPerks_Idx18"    :    return
//    case     "DBD_Chapter14_Slasher_Stat1"    :    return
    case     "DBD_Chapter14_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435473"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapHti_Shrine"    :    return
    case     "DBD_Chapter14_Camper_Stat1"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx19"    :    return
    case     "DBD_Chapter15_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter15_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435474"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapUkr_Saloon"    :    return
    case     "DBD_Chapter15_Camper_Stat1"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx20"    :    return
    case     "DBD_Chapter16_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter16_Slasher_Stat2"    :    return    "Killer"
//    case     "DBD_FinishWithPerks_Idx268435475"    :    return
//    case     "DBD_FixSecondFloorGenerator_MapWal_Level_01"    :    return
    case     "DBD_Chapter16_Camper_Stat1_float"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx21"    :    return
    case     "DBD_Chapter17_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter17_Slasher_Stat2"    :    return    "Killer"
    //case     "DBD_FinishWithPerks_Idx268435476"    :    return
    case     "DBD_Chapter17_Camper_Stat1"    :    return    "Survivor"
    case     "DBD_Chapter17_Camper_Stat2_float"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx22"    :    return
    case     "DBD_Chapter18_Slasher_Stat1"    :    return    "Killer"
    case     "DBD_Chapter18_Slasher_Stat2"    :    return    "Killer"
    case     "DBD_Chapter18_Camper_Stat1"    :    return    "Survivor"
    case     "DBD_Chapter18_Camper_Stat2_float"    :    return    "Survivor"
    //case     "DBD_FinishWithPerks_Idx23"    :    return
    //case     "DBD_FinishWithPerks_Idx268435477"    :    return
        
    default:
        return ""
    }
}


