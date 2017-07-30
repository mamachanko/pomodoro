package io.github.mamachanko.featuretests

import com.google.common.truth.Truth.assertThat
import io.github.bonigarcia.wdm.ChromeDriverManager
import org.fluentlenium.adapter.junit.FluentTest
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Configuration
import org.springframework.test.context.junit4.SpringRunner

@Configuration
@ConfigurationProperties(prefix = "test")
class TestConfig {
    lateinit var url: String
}

@RunWith(SpringRunner::class)
@SpringBootTest
class PomodoroFeatureTests : FluentTest() {

    @Autowired
    lateinit var config: TestConfig

    companion object {
        @BeforeClass @JvmStatic
        fun setupClass() {
            ChromeDriverManager.getInstance().setup()
        }
    }

    @Before
    fun setUp() {
        if (config.url.isBlank()) throw RuntimeException("TEST_URL must be set")
    }

    @Test
    fun `I can use the Pomodoro app`() {
        goTo(config.url)
        assertThat(`$`("#timer").text()).isEqualTo("25:00")
    }

}
