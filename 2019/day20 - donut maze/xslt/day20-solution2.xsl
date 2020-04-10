<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:variable name="root" select="/"/>
    <xsl:variable name="zz-line" select="//cell[@text='ZZ']/@line"/>
    <xsl:variable name="zz-column" select="//cell[@text='ZZ']/@column"/>
    
    <xsl:template match="/">
        <xsl:call-template name="calculate-distances">
            <xsl:with-param name="current-distance" select="0"/>
            <xsl:with-param name="best-distance" select="0"/>
            <xsl:with-param name="intersections">
                <intersections>
                    <intersection line="{//distances/cell[@text='AA']/@line}" column="{//distances/cell[@text='AA']/@column}" distance="0" floor="0"/>
                </intersections>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="calculate-distances">
        <xsl:param name="best-distance" as="xs:double"/>
        <xsl:param name="current-distance" as="xs:double"/>
        <xsl:param name="intersections" as="node()"/>
        
        <xsl:choose>
            <xsl:when test="$best-distance != 0 and $best-distance &lt;= $current-distance">
                <!-- Un de trop compté au départ de AA -->
                <xsl:value-of select="$best-distance -1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-intersections">
                    <intersections>
                        <xsl:for-each select="$intersections//intersection[@distance=$current-distance]">
                            <xsl:variable name="current-line" select="@line"/>
                            <xsl:variable name="current-column" select="@column"/>
                            <xsl:variable name="current-floor" select="@floor"/>
                            <xsl:for-each select="$root//distances/cell[@line=$current-line and @column=$current-column]/cell">
                                <xsl:if test="(@text!='ZZ' and $current-floor + @floor &lt;= 0) or (@text='ZZ' and $current-floor + @floor = 0)">
                                    <intersection line="{@line}" column="{@column}" distance="{$current-distance + number(@distance)}" floor="{$current-floor + @floor}"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </intersections>
                </xsl:variable>
                <xsl:variable name="total-intersections">
                    <intersections>
                        <xsl:for-each select="$intersections//intersection">
                            <xsl:if test="not($new-intersections//intersection[@line=current()/@line and @column=current()/@column and @floor=current()/@floor and @distance &lt; current()/@distance])">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="$new-intersections//intersection">
                            <xsl:if test="not($intersections//intersection[@line=current()/@line and @column=current()/@column and @floor=current()/@floor and @distance &lt;= current()/@distance])
                                  and not($new-intersections//intersection[@line=current()/@line and @column=current()/@column and @floor=current()/@floor and @distance &lt; current()/@distance])">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </intersections>
                </xsl:variable>
                <xsl:variable name="new-ZZ-distance" select="min($new-intersections//intersection[@line=$zz-line and @column=$zz-column]/number(@distance))"/>
                <xsl:call-template name="calculate-distances">
                    <xsl:with-param name="intersections" select="$total-intersections" as="node()"/>
                    <xsl:with-param name="current-distance" select="min($total-intersections//intersection[@distance &gt; $current-distance]/@distance)"/>
                    <xsl:with-param name="best-distance">
                        <xsl:choose>
                            <xsl:when test="string($new-ZZ-distance) != '' and ($best-distance=0 or $best-distance &gt; $new-ZZ-distance)">
                                <xsl:value-of select="$new-ZZ-distance"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$best-distance"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>