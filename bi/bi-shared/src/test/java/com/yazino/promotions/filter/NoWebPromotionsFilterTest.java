package com.yazino.promotions.filter;

import com.google.common.collect.Collections2;
import org.junit.Test;
import strata.server.lobby.api.promotion.Promotion;

import java.util.List;

import static com.google.common.collect.Lists.newArrayList;
import static org.hamcrest.CoreMatchers.hasItem;
import static org.hamcrest.CoreMatchers.not;
import static org.junit.Assert.assertThat;

public class NoWebPromotionsFilterTest extends AbstractPromotionsPlatformFilterTest {

    @Test
    public void shouldFilterPromotionsThatAreNotForWeb() {

        // GIVEN promotions for Web only, iOS only and one for both
        List<Promotion> promotions = createPromotionList();

        // WHEN filtering
        promotions = newArrayList(Collections2.filter(promotions, new NoWebPromotionsFilter()));

        // THEN promotions without max rewards should be removed
        assertThat(promotions, hasItem(buyChipsPromotionForWeb));
        assertThat(promotions, hasItem(buyChipsPromotionForWebAndIos));
        assertThat(promotions, not(hasItem(buyChipsPromotionForIos)));
    }

}
