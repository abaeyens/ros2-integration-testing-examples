#include <gtest/gtest.h>

TEST(dummysuite, dummytestcase) {
    // Don't test any actual functionality, just dummy
    EXPECT_EQ(2, 2);
    EXPECT_GT(3, 1);
}

TEST(dummysuite, dummytestcasebis) {
    // Don't test any actual functionality, just dummy
    EXPECT_EQ(3, 3);
    EXPECT_GT(4, 2);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
